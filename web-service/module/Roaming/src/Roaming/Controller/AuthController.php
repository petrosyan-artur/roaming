<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

namespace Roaming\Controller;

/**
 * Description of AuthController
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
class AuthController extends AbstractBaseController {

    protected $storage;


    /**
     * 
     * @return \Roaming\Model\User
     */
    protected function getUserModel() {
        return $this->getServiceLocator()->get('\Roaming\Model\User');
        
    }

    protected function getSessionStorage() {
        if (!$this->storage) {
            $this->storage = $this->getServiceLocator()
                    ->get('Roaming\Auth\AuthStorage');
        }

        return $this->storage;
    }

    /**
     * 
     * @return type
     * 
     * @returncodes 
     *      RESPONSE_STATUS_OK
     *      RESPONSE_STATUS_LOIN_REQUIRED
     * 
     */
    public function getSipConfigAction() {
        
        if(!$this->getAuthService()->hasIdentity()) {
            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_LOIN_REQUIRED);
        }
        
        $user = $this->getLoggedInUser();
        $sipConfig = new \Roaming\Entity\SipConfiguration();
        $sipConfig->setUsername($user->name);
        $sipConfig->setPassword($user->secret);
        
        return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_OK, array('sip' => $sipConfig));
    }

    /**
     * 
     * @request POST
     * 
     * @param phone string
     * @param pin string
     * 
     * @return Json
     * 
     * @returncodes 
     *      RESPONSE_STATUS_OK
     *      RESPONSE_STATUS_INVALID_PARAMETERS
     *      RESPONSE_STATUS_AUTH_ERROR
     *      RESPONSE_STATUS_INVALID_REQUEST
     *      RESPONSE_STATUS_UNKNOWN_ERROR
     *      RESPONSE_STATUS_USER_ACTIVATION_ERROR
     */
    public function authenticateAction() {

        $request = $this->getRequest();
        if ($request->isPost()) {
            if($this->getAuthService()->hasIdentity()) {
                return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_ALREADY_LOGGED_IN);
            }
            
            $phone = $request->getPost('phone', null);
            $pin = $request->getPost('pin', null);
            $client_version = $request->getPost('app_version', null);
            
            if(is_null($pin) || is_null($phone) || /*is_null($device_token) ||*/ is_null($client_version)) {
                return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_PARAMETERS);
            }
            
            $adapter = $this->getAuthService()->getAdapter();

            try {
                //check if the user is pending
                $isUserPending = $this->getUserModel()->isUserPending($phone);
                if($isUserPending) {
                    $adapter->setTableName('user_pending');
                }

                //check authentication...
                $adapter->setIdentity($phone)->setCredential($pin);
                $this->startTransaction();
                $result = $this->getAuthService()->authenticate();
                if ($result->isValid()) {
                    $userObject = $adapter->getResultRowObject();
                    $this->getUserModel()->updateClientLoginData($client_version, $userObject->name);
                    $sipData = new \Roaming\Entity\SipConfiguration();
                    $sipData->setPassword($userObject->secret);
                    $sipData->setUsername($userObject->name);
                    $this->getAuthService()->setStorage($this->getSessionStorage());
                    $this->getAuthService()->getStorage()->write($phone);
                    $this->transactionCommit();
                    return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_OK, array('sip' => $sipData));
                } else {
                    $errors = array();
                    foreach ($result->getMessages() as $message) {
                        //save message temporary into flashmessenger
                        $errors[] = $message;
                    }
                    $this->transactionCommit();
                    return $this->getJsonModel($result->getCode(), array(), $errors);
                }
                $this->transactionCommit();
            } catch (\Exception $ex) {
                $this->transactionRollback();
                return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_USER_ACTIVATION_ERROR, array(), array($ex->getMessage()));
            }
        }
            
        return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_REQUEST, array(), array('only post request accepted'));
    }

    /**
     * 
     * @return type
     * 
     * @returncodes 
     *      RESPONSE_STATUS_OK
     *      RESPONSE_STATUS_NOT_LOGGED_IN
     * 
     */
    public function logoutAction() {
        
        if(!$this->getAuthService()->hasIdentity()) {
            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_NOT_LOGGED_IN);
        }
        
        $this->getSessionStorage()->forgetMe();
        $this->getAuthService()->clearIdentity();
        
        return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_OK);
    }
}
