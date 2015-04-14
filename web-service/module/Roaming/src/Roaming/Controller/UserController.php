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
        
        return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_OK, array('next_try' => self::NEXT_TRY));
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
        
        if($this->getAuthService()->hasIdentity() && 0 /*@TODO REMOVE*/) {
            $this->log(self::LOG_DEBUG, "User has identity", (array) $this->getAuthService()->getIdentity());
            try {
                return $this->requestPinForLoggedUser();
            } catch (\Exception $exc) {
                $code = $exc->getCode();
                if(!\Roaming\Helper\RespCodes::checkRespCodeExist($code)) {
                    $code = \Roaming\Helper\RespCodes::RESPONSE_STATUS_UNKNOWN_ERROR;
                }
                $this->log(self::LOG_WARN, "Exception occured: ". $exc->getMessage(), $exc->getTrace());
                return $this->getJsonModel($code, array(), array($exc->getMessage()));
            }
        } else {
            $this->log(self::LOG_DEBUG, "User has NO identity");
        }
        
        $request = $this->getRequest();
        
        if (!$request->isPost()) {
            $this->log(self::LOG_WARN, "Request is not POST, but shold be (exiting) !!!");
            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_REQUEST, array(), array('only post request accepted'));
        }
        
        $phone = $request->getPost('phone');
        
        if(!$phone) {
            $this->log(self::LOG_WARN, "No Phone parameter in the post", $request->getPost());
            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_PARAMETERS, array(), array('phone number missing'));
        }
        
        $validator = new \Zend\Validator\Digits();
        if(!$validator->isValid($phone)) {
            $this->log(self::LOG_WARN, "Invalid phone", array($phone));
            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_PARAMETERS, array(), array_values($validator->getMessages()));
        }
        
        $userModel = $this->getUserModel();
        
        try {
            if(!$userModel->registered($phone)) {
                $this->log(self::LOG_DEBUG, "User is not registered, registering user", array($phone));
                $userModel->register($phone);
            } else {
                $this->log(self::LOG_DEBUG, "User is already registered", array($phone));
            }
            
            
            $this->log(self::LOG_DEBUG, "Generating and sending pin");
            $userModel->generateAndSendPin($phone);
        } catch (\Exception $exc) {
            $code = $exc->getCode();
            if(!\Roaming\Helper\RespCodes::checkRespCodeExist($code)) {
                $code = \Roaming\Helper\RespCodes::RESPONSE_STATUS_UNKNOWN_ERROR;
            }
            $this->log(self::LOG_WARN, "Exception occured: ". $exc->getMessage(), $exc->getTrace());
            return $this->getJsonModel($code, array(), array($exc->getMessage()));
        }
        
        $responseData = array('next_try' => self::NEXT_TRY);
        
        $this->log(self::LOG_DEBUG, "Sending OK Response", $responseData);
        
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

    public function accountInfoAction() {

        $user = $this->getLoggedinUser();

        if(!$user) {
            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_NOT_LOGGED_IN);
        }

        $responseData = array(
            'balance' => array(
                'active_days' => 10,
                'bonus_days' => 5
            ),
            'available_subscribtions' => array(
                array(
                    'price' => '10 USD',
                    'duration' => '5 days',
                    'url' => 'http://37.48.84.64/api/payment/buy-subscription?type=1',
                ),
                array(
                    'price' => '20 USD',
                    'duration' => '15 days',
                    'url' => 'http://37.48.84.64/api/payment/buy-subscription?type=2'
                )
            )
        );
        return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_OK, $responseData);
    }

    public function accountHistoryAction() {
        $request = $this->getRequest();

        $user = $this->getLoggedinUser();
        $this->layout('layout/mobile');
    }
}
