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
    
    public $server_ip;

    public function __construct() {
        $this->setServer_ip('95.211.27.30');
    }
    
    public function getUsername() {
        return $this->username;
    }

    public function getPassword() {
        return $this->password;
    }

    public function getServer_ip() {
        return $this->server_ip;
    }

    public function setUsername($username) {
        $this->username = $username;
    }

    public function setPassword($password) {
        $this->password = $password;
    }

    public function setServer_ip($server_ip) {
        $this->server_ip = $server_ip;
    }


    
}
