<?php

namespace Roaming\Controller;


class UserController extends AbstractBaseController {
    
    const NEXT_TRY = 120;
    
    /**
     *
     * @var /Roaming/Model/User
     */
    protected $userModel = null;
    
    protected function requestPinForLoggedUser() {
        $userModel = $this->getUserModel();    
        $userModel->generateAndSendPin($this->getLoogedinUserIdentity());
        
        //logout
        $this->getServiceLocator()->get('\Roaming\Auth\AuthStorage')->forgetMe();
        $this->getServiceLocator()->get('\Roaming\Auth\AuthService')->clearIdentity();
        
        return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_OK);
    }

    public function addCronAction() {
        $a = \Heartsentwined\Cron\Service\Cron::register(
            'handle_temporary_blokced',
            '*/15 * * * *',
            '\Roaming\Model\User::handleTemporaryBlockedUsers'
        );
        var_dump($a);
        echo 'ok';
        die;
    }
    
    /**
     * 
     * @return JsonModel
     * 
     * @returncodes 
     *      RESPONSE_STATUS_OK
     *      RESPONSE_STATUS_SMS_LIMIT_EXCEEDED
     *      RESPONSE_STATUS_TWILIO_MESSAGE_SENDING_EXCEPTION
     *      RESPONSE_STATUS_UNKNOWN_ERROR
     *      RESPONSE_STATUS_INVALID_REQUEST
     */
    public function requestPinAction() {
        if($this->getAuthService()->hasIdentity()) {
            try {
                return $this->requestPinForLoggedUser();
            } catch (\Exception $exc) {
                $code = $exc->getCode();
                if(!\Roaming\Helper\RespCodes::checkRespCodeExist($code)) {
                    $code = \Roaming\Helper\RespCodes::RESPONSE_STATUS_UNKNOWN_ERROR;
                }
                return $this->getJsonModel($code, array(), array($exc->getMessage()));
            }
        }
        
        $request = $this->getRequest();
        
        if (!$request->isPost()) {
            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_REQUEST, array(), array('only post request accepted'));
        }
        
        $phone = $request->getPost('phone');
        
        if(!$phone) {
            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_PARAMETERS, array(), array('phone number missing'));
        }
        
        $validator = new \Zend\Validator\Digits();
        if(!$validator->isValid($phone)) {
            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_PARAMETERS, array(), array_values($validator->getMessages()));
        }
        
        $userModel = $this->getUserModel();
        
        try {
            if(!$userModel->registered($phone)) {
                $userModel->register($phone, array('country_id' => 1, 'rate_sheet_id' => 1));
            }
            
            $userModel->generateAndSendPin($phone);
        } catch (\Exception $exc) {
            $code = $exc->getCode();
            if(!\Roaming\Helper\RespCodes::checkRespCodeExist($code)) {
                $code = \Roaming\Helper\RespCodes::RESPONSE_STATUS_UNKNOWN_ERROR;
            }
            return $this->getJsonModel($code, array(), array($exc->getMessage()));
        }
        
        $responseData = array('next_try' => self::NEXT_TRY);
        
        return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_OK, $responseData);
    }
    
    /**
     * 
     * @return \Roaming\Model\User
     */
    public function getUserModel() {
        if($this->userModel === null) {
            $this->userModel = $this->getServiceLocator()->get('\Roaming\Model\User');
        }
        return $this->userModel;
    }
}
