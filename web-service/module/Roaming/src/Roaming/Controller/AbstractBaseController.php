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
    
    const LOG_INFO = 1;
    const LOG_DEBUG = 2;
    const LOG_WARN = 3;
    
    protected $authservice;
    
    protected $loggedInUserIdentity;

    protected $logger;
    
    public function __construct() {
        $writer = new \Zend\Log\Writer\Stream('/var/www/telasco-roaming/web-service/logs/app.log');
        $this->logger = new \Zend\Log\Logger;
        $this->logger->addWriter($writer);
    }
    
    protected function log($loglevel, $message, $data = []) {
        if(!is_array($data)) {
            $data = array($data);
        }
        switch ($loglevel) {
            case self::LOG_DEBUG:
                $this->logger->debug($message, $data);
                break;
            case self::LOG_INFO:
                $this->logger->info($message, $data);
                break;
            case self::LOG_WARN:
                $this->logger->warn($message, $data);
                break;
            default:
                break;
        }
        
    }
    
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
    
    public function startTransaction() {
        $this->getServiceLocator()->get('Zend\Db\Adapter\Adapter')->getDriver()->getConnection()->beginTransaction();
    }
    
    public function transactionCommit() {
        $this->getServiceLocator()->get('Zend\Db\Adapter\Adapter')->getDriver()->getConnection()->commit();
    }
    
    public function transactionRollback() {
        $this->getServiceLocator()->get('Zend\Db\Adapter\Adapter')->getDriver()->getConnection()->rollback();
    }
    
    protected function getLoggedinUser() {
        $userIdentity = $this->getLoogedinUserIdentity();
        if(!$userIdentity) {
            return null;
        }
        return $this->getServiceLocator()->get('\Roaming\DbMapper\User')->getUserByIdentity($userIdentity);
    }
    
    /**
     * 
     * @param type $status
     * @param array $data
     * @param array $errors
     * @return \Zend\View\Model\JsonModel
     */
    protected function getJsonModel($status, array $data = array(), array $errors = array()) {
        if($errors) {
            $error = array_pop($errors);
        } elseif($status !== \Roaming\Helper\RespCodes::RESPONSE_STATUS_OK) {
            $error = '';
        } else {
            $error = NULL;
        }
        $all = array('data' => $data, 'errors' => $error, 'status' => $status);
        return new \Zend\View\Model\JsonModel($all);
    }
    
    protected function getLoogedinUserIdentity() {
        if(!$this->getAuthService()->hasIdentity()) {
//            return null;
            //@TODO change after testing
            return '12886666666';
        }
        
        if (!$this->loggedInUserIdentity) {
            $authService = $this->getServiceLocator()->get('\Roaming\Auth\AuthService');
            $this->loggedInUserIdentity = $authService->getIdentity();
        }

        return $this->loggedInUserIdentity;
    }    

}