<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

namespace Roaming\Controller;

/**
 * Description of AbstractBaseController
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
class AbstractBaseController extends \Zend\Mvc\Controller\AbstractActionController {
    
    
    protected $authservice;
    
    protected $loggedInUserIdentity;

    /**
     * 
     * @return \Zend\Authentication\AuthenticationService
     */
    protected function getAuthService() {
        if (!$this->authservice) {
            $this->authservice = $this->getServiceLocator()
                    ->get('\Roaming\Auth\AuthService');
        }

        return $this->authservice;
    }
    
    /**
     * 
     * @param type $status
     * @param array $data
     * @param array $errors
     * @return \Zend\View\Model\JsonModel
     */
    protected function getJsonModel($status, array $data = array(), array $errors = array()) {
        $all = array('data' => $data, 'errors' => $errors, 'status' => $status);
        return new \Zend\View\Model\JsonModel($all);
    }
    
    protected function getLoogedinUserIdentity() {
        if(!$this->getAuthService()->hasIdentity()) {
            throw new \Exception('not logged in', \Roaming\Helper\RespCodes::RESPONSE_STATUS_LOIN_REQUIRED);
        }
        
        if (!$this->loggedInUserIdentity) {
            $authService = $this->getServiceLocator()->get('\Roaming\Auth\AuthService');
            $this->loggedInUserIdentity = $authService->getIdentity();
        }

        return $this->loggedInUserIdentity;
    }
    
    protected function getLoggedInUser() {
        $identity = $this->getLoogedinUserIdentity();
        return $userMapper = $this->getServiceLocator()->get('\Roaming\DbMapper\User')->getUserByIdentity($identity);
    }
    
}