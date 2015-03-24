<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

namespace Roaming\Auth;

/**
 * Description of AuthStorage
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
class AuthStorage extends \Zend\Authentication\Storage\Session {
    
    public function __construct($namespace = null, $member = null, \Zend\Session\ManagerInterface $manager = null) {
        parent::__construct($namespace, $member, $manager);
        var_dump($this->session->getManager()->getName());die;
        $this->session->getManager()->rememberMe(60 * 60 * 24 * 365 * 5); //2 years @TODO move to config
    }
    
    public function forgetMe() {
        $this->session->getManager()->forgetMe();
    } 
}
