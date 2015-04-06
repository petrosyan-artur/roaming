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
                
                $this->log(self::LOG_DEBUG, "Auth: User HAS identity, clearing it");
                
                $this->getSessionStorage()->forgetMe();
                $this->getAuthService()->clearIdentity();
                
                //@TODO change
                //return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_ALREADY_LOGGED_IN);
            }
            
            $phone = $request->getPost('phone', null);
            $pin = $request->getPost('pin', null);
            $client_version = $request->getPost('app_version', null);
            $device_token = $request->getPost('device_token', null);
            
            if(is_null($pin) || is_null($phone) || is_null($device_token)  || is_null($client_version)) {
                $this->log(self::LOG_WARN, "Auth: Invalid parameters", $request->getPost());
                return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_PARAMETERS);
            }
            
            $adapter = $this->getAuthService()->getAdapter();

            try {
                //check if the user is pending
                $isUserPending = $this->getUserModel()->isUserPending($phone);
                if($isUserPending) {
                    $this->log(self::LOG_DEBUG, "Auth: User is in pending state");
                    $adapter->setTableName('user_pending');
                }

                //check authentication...
                $adapter->setIdentity($phone)->setCredential($pin);
                $this->startTransaction();
                $result = $this->getAuthService()->authenticate();
                if ($result->isValid()) {
                    $this->log(self::LOG_DEBUG, "Auth: User provided parameters are valid", $request->getPost());
                    $userObject = $adapter->getResultRowObject();
                    $this->getUserModel()->updateClientLoginData($device_token, $client_version, $userObject->name);
                    $sipData = new \Roaming\Entity\SipConfiguration();
                    $sipData->setPassword($userObject->secret);
                    $sipData->setUsername($userObject->name);
                    $this->getAuthService()->setStorage($this->getSessionStorage());
                    $this->getAuthService()->getStorage()->write($phone);
                    $this->transactionCommit();
                    $sessionId = $this->getAuthService()->getStorage()->getSessionManager()->getManager()->getId();
                    error_log($sessionId);

                    $this->log(self::LOG_DEBUG, "Auth: Returning OK response", $sipData);
                    return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_OK, array('sip' => $sipData));
                } else {
                    $errors = array();
                    $this->log(self::LOG_WARN, "Auth: User provided parameters are NOT valid", $request->getPost());
                    foreach ($result->getMessages() as $message) {
                        //save message temporary into flashmessenger
                        $errors[] = $message;
                    }
                    $this->transactionCommit();
                    $this->log(self::LOG_WARN, "Auth: Returning ERROR response", $errors);
                    return $this->getJsonModel($result->getCode(), array(), $errors);
                }
                $this->transactionCommit();
            } catch (\Exception $ex) {
                $this->transactionRollback();
                $this->log(self::LOG_WARN, "Auth: Exception occured, " . $ex->getMessage(), array($ex->getTrace()));
                return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_USER_ACTIVATION_ERROR, array(), array($ex->getTrace()));
            }
        } else {
            $this->log(self::LOG_WARN, "Auth: Invalid request, not post request", $request->getPost());
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
