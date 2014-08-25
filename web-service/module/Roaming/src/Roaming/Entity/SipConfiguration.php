<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

namespace Roaming\Entity;

/**
 * Description of SipConfiguration
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
class SipConfiguration {
    
    public $username;
    
    public $password;
    
    public $host;
    
    public $port;

    public function __construct() {
        $this->setHost('95.211.27.30');
        $this->setPort('5060');
    }
    
    public function getUsername() {
        return $this->username;
    }

    public function getPassword() {
        return $this->password;
    }

    public function getHost() {
        return $this->host;
    }

    public function setUsername($username) {
        $this->username = $username;
    }

    public function setPassword($password) {
        $this->password = $password;
    }

    public function setHost($server_ip) {
        $this->host = $server_ip;
    }

    public function getPort() {
        return $this->port;
    }

    public function setPort($port) {
        $this->port = $port;
    }
}
