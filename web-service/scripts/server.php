<?php

//define('REQUEST_FROM_ASTERISK', 1);
//define('REQUEST_FROM_CLIENT', 2);
define('MAX_DATA_SIZE', 30);

$null = NULL; //null var
//Create TCP/IP sream socket
$socket_for_asterix_proxy = socket_create(AF_UNIX, SOCK_STREAM, 0);

$socket_for_mobile_clients = socket_create(AF_INET, SOCK_STREAM, 0);
socket_set_option($socket_for_mobile_clients, SOL_SOCKET, SO_REUSEADDR, 1);

$server_side_sock = dirname(__FILE__) . "/server.sock";

if (!socket_bind($socket_for_asterix_proxy, $server_side_sock)) {
    die("Unable to bind to $server_side_sock");
}

if (!socket_bind($socket_for_mobile_clients, 0, 4456)) {
    die("Unable to bind to 4456");
}

//listen to port
socket_listen($socket_for_asterix_proxy);
socket_listen($socket_for_mobile_clients);

$asterisk_sockets = array();

//start endless loop, so that our script doesn't stop
while (true) {
    //manage multipal connections
    $changed = array_merge(array($socket_for_asterix_proxy, $socket_for_mobile_clients), $asterisk_sockets);
    //returns the socket resources in $changed array
    socket_select($changed, $null, $null, null);

    echo "starting parse sockets: " .sizeof($changed) . "\n";
    
    while(sizeof($changed) > 0) {
        $sock = array_pop($changed);

        if($sock === $socket_for_asterix_proxy) { //new socket from asterix
            $socket_new_asterix = socket_accept($sock);
            
            echo "new Socket \n";
            
            $header_asterix = socket_read($socket_new_asterix, MAX_DATA_SIZE + 5, PHP_BINARY_READ); //read new socket data to see if it is from client or asterisk
            if(strlen($header_asterix) > MAX_DATA_SIZE || $header_asterix === false) { //data size from socket should not exceed limit, we drop flooding sockets
                echo "size exceed on unknown closing\n";
                @socket_close($socket_new_asterix);
                continue;
            }
            
            echo "from asterix\n";
            $phone_number_from_asterix = $header_asterix;
            $asterisk_sockets[$phone_number_from_asterix] = $socket_new_asterix;
        } elseif($sock === $socket_for_mobile_clients) { //mobile clients
            $socket_new_client = socket_accept($sock);
            echo "client connecting send that to asterix\n";
            
            $header_from_client = socket_read($socket_new_client, MAX_DATA_SIZE + 5, PHP_BINARY_READ); //read new socket data to see if it is from client or asterisk
            if(strlen($header_from_client) > MAX_DATA_SIZE || $header_from_client === false) { //data size from socket should not exceed limit, we drop flooding sockets
                echo "size exceed on unknown closing\n";
                @socket_close($socket_new_client);
                continue;
            }
            
            $phone_number_from_client = $header_from_client;
            //client responded, fine, now lets tell asterisk proxy
            if(isset($asterisk_sockets[$phone_number_from_client])) {
                echo "sending to asterix\n";
                send_success_message($asterisk_sockets[$phone_number_from_client], "1");
                @socket_close($asterisk_sockets[$phone_number_from_client]);
                @socket_close($socket_new_client);
                unset($asterisk_sockets[$phone_number_from_client]);
            } else {
                echo "asterix not found, telling that to client\n";
                send_success_message($socket_new_client, '0');
                @socket_close($socket_new_client);
            }
        } else { //asterisk proxy existing socket, it should be only disconnect request, so we just disconnect socket (asterix should not talk more)
            echo "from existing asterix, closing asterix\n";
            @socket_close($sock);
            if (($key = array_search($sock, $asterisk_sockets)) !== false) {
                unset($asterisk_sockets[$key]);
                echo "removed\n";
            }
        }
    }
}

// close the listening socket
@socket_close($sock);

function send_success_message($client, $msg) {
    @socket_write($client, $msg, strlen($msg));
    return true;
}