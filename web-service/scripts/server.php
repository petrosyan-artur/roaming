<?php

define('REQUEST_FROM_ASTERISK', 1);
define('REQUEST_FROM_CLIENT', 2);
define('MAX_DATA_SIZE', 30);

$null = NULL; //null var
//Create TCP/IP sream socket
$socket = socket_create(AF_UNIX, SOCK_STREAM, 0);
//reuseable port
//socket_set_option($socket, SOL_SOCKET, SO_REUSEADDR, 1);

$server_side_sock = dirname(__FILE__) . "/server.sock";

if (!socket_bind($socket, $server_side_sock)) {
    die("Unable to bind to $server_side_sock");
}

//listen to port
socket_listen($socket);

$asterisk_sockets = array();

//start endless loop, so that our script doesn't stop
while (true) {
    //manage multipal connections
    $changed = array_merge(array($socket), $asterisk_sockets);
    //returns the socket resources in $changed array
    socket_select($changed, $null, $null, 0, 10);

    while(sizeof($changed) > 1) {
        $sock = array_pop($changed);
        
        if($sock === $socket) { //new socket
            $socket_new = socket_accept($sock);
            
            echo "new Socket \n";
            
            $header = @socket_read($socket_new, MAX_DATA_SIZE + 5, PHP_NORMAL_READ); //read new socket data to see if it is from client or asterisk
            if(sizeof($header) > MAX_DATA_SIZE || $header === false) { //data size from socket should not exceed limit, we drop flooding sockets
                echo "size exceed on unknown closing\n";
                @socket_close($socket_new);
                continue;
            }
            
            if($header[0] == REQUEST_FROM_ASTERISK) {
                echo "from asterix\n";
                $phone_number = substr($header, 1);
                $asterisk_sockets[$phone_number] = $socket_new;
            } elseif($header[0] == REQUEST_FROM_CLIENT) {
                echo "client connecting send that to asterix\n";
                $phone_number = substr($header, 1);
                //client responded, fine, now lets tell asterisk proxy
                if(isset($asterisk_sockets[$phone_number])) {
                    @send_success_message($asterisk_sockets[$phone_number], '1');
                } else {
                    @send_success_message($socket_new, 0);
                }
            }
            
        } else { //asterisk proxy existing socket, it should be only disconnect request, so we just disconnect socket
            echo "from existing asterix, closing asterix\n";
            @socket_close($sock);
            unset($asterisk_sockets[$phone_number]);
        }
    }
}

// close the listening socket
socket_close($sock);

function send_success_message($client, $msg) {
    @socket_write($client, $msg, strlen($msg));
    return true;
}