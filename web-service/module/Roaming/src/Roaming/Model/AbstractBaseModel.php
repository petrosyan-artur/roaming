<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

namespace Roaming\Model;

/**
 * Description of AbstractBaseModel
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
class AbstractBaseModel {
    
    protected $serviceLocator;
    
    public function __construct(\Zend\ServiceManager\ServiceLocatorInterface $sm) {
        $this->serviceLocator = $sm;
    }
    
    /**
     * 
     * @return \Zend\ServiceManager\ServiceLocatorInterface
     */
    public function getServiceLocator() {
        return $this->serviceLocator;
    }
}
