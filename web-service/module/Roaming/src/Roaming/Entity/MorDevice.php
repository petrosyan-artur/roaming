<?php

namespace Roaming\Entity;

/**
 * Description of DeviceEntity
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
class MorDevice {
    
    const TYPE_SIP = 'SIP';
    const TYPE_IAX2 = 'IAX2';
    
    const STATUS_ACTIVE = 1;
    const STATUS_DISABLED = 0;
    
    protected $name;
    
    protected $username;
    
    protected $password;
    
    protected $type;
    
    protected $id;
    
    protected $pin;
    
    protected $asteriskServerIp;

    protected $status;
    
    public function getUsername() {
        return $this->username;
    }

    public function getPassword() {
        return $this->password;
    }

    public function getType() {
        return $this->type;
    }

    public function getId() {
        return $this->id;
    }

    public function getPin() {
        return $this->pin;
    }

    public function getAsteriskServerIp() {
        return $this->asteriskServerIp;
    }

    public function setUsername($username) {
        $this->username = $username;
    }

    public function setPassword($password) {
        $this->password = $password;
    }

    public function setType($type) {
        $this->type = $type;
    }

    public function setId($id) {
        $this->id = $id;
    }

    public function setPin($pin) {
        $this->pin = $pin;
    }

    public function setAsteriskServerIp($asteriskServerIp) {
        $this->asteriskServerIp = $asteriskServerIp;
    }

    public function getName() {
        return $this->name;
    }

    public function setName($name) {
        $this->name = $name;
    }
    
    
    public function getStatus() {
        return $this->status;
    }

    public function setStatus($status) {
        $this->status = $status;
    }

}
