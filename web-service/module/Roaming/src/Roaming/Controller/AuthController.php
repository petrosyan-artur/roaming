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
        $sipConfig->setUsername($user->sip_username);
        $sipConfig->setPassword($user->sip_password);
        
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
            if(is_null($pin) || is_null($phone)) {
                return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_PARAMETERS);
            }
            
            $adapter = $this->getAuthService()->getAdapter();
            
            //check authentication...
            $adapter->setIdentity($request->getPost('phone'))
                    ->setCredential($request->getPost('pin'));

            $result = $this->getAuthService()->authenticate();

            if ($result->isValid()) {
                
                //if status is pending just activate in first login !!
                $userObject = $adapter->getResultRowObject();
                
                $sipData = new \Roaming\Entity\SipConfiguration();
                
                try {
                    if((int) $userObject->status === \Roaming\DbMapper\User::STATUS_PENDING) {
                        $ret = $this->getUserModel()->activate($userObject);
                        if(is_null($ret)) {
                            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_UNKNOWN_ERROR);
                        }
                        $device = $ret->getDeviceEntity();
                        $sipData->setPassword($device->getPassword());
                        $sipData->setUsername($device->getUsername());
                        $sipData->getServer_ip($device->getAsteriskServerIp());
                    } else {
                        $sipData->setPassword($userObject->sip_password);
                        $sipData->setUsername($userObject->sip_username);
                    }

                } catch (\Exception $ex) {
                    return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_USER_ACTIVATION_ERROR, array(), array($ex->getMessage()));
                }
                
                $this->getAuthService()->setStorage($this->getSessionStorage());
                    
                //$this->getAuthService()->getAdapter()->getResultRowObject()
                $this->getAuthService()->getStorage()->write($phone);
                return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_OK, array('sip' => $sipData));
            } else {
                $errors = array();
                foreach ($result->getMessages() as $message) {
                    //save message temporary into flashmessenger
                    $errors[] = $message;
                }
                return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_AUTH_ERROR, array(), $errors);
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
