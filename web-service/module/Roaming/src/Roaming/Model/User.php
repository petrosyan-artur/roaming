<?php

namespace Roaming\Model;

/**
 * Description of User
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
class User extends AbstractBaseModel {
    
    const PIN_REQUEST_DAILY_LIMIT = 10;
    
    /**
     *
     * @var \Roaming\DbMapper\User
     */
    protected $mapper;
    
    public function __construct(\Roaming\DbMapper\User $mapper, \Zend\ServiceManager\ServiceLocatorInterface $sm) {
        parent::__construct($sm);
        $this->mapper = $mapper;
    }
    
    public function getUsers() {
        return $this->mapper->select();
    }
    
    protected function generatePin() {
        return mt_rand(10000, 99999);
    }

    public function registered($phone) {
        $user = $this->mapper->getUserByIdentity($phone);
        return !!$user;
    }
    
    public function register($phone) {
        $user = $this->mapper->getUserByIdentity($phone);
        if($user) {
            return;
        }
        $data = array('phone' => $phone, 'status' => \Roaming\DbMapper\User::STATUS_PENDING);
        return $this->mapper->insert($data);
    }
    
    /**
     * 
     * @param type $user
     * @return \Roaming\Entity\MorUserRegisterResponse | null 
     */
    public function activate($user) {
        
        $morModule = $this->getMorModel();
        $morResponse = $morModule->register($user->phone);

        if($morResponse->getStatus() === \Roaming\Entity\MorUserRegisterResponse::STATUS_SUCCESS) {
            $userUpdateData = array();
            $userUpdateData['status'] = \Roaming\DbMapper\User::STATUS_ACTIVE;
            $userUpdateData['sip_username'] = $morResponse->getDeviceEntity()->getUsername();
            $userUpdateData['sip_password'] = $morResponse->getDeviceEntity()->getPassword();
            $userUpdateData['mor_user_id'] = $morResponse->getMoreUserId();
            if($this->mapper->update($userUpdateData)) {
                return $morResponse;
            }
        }

        return null;
    }
    
    public function generateAndSendPin($userIdentity) {        
        $user = $this->mapper->getUserByIdentity($userIdentity);
        $pinRequestMapper = $this->getPinRequestMapper();
        
        $res = $this->getPinRequestMapper()->select(function (\Zend\Db\Sql\Select $select){
            $select->columns(array('num' => new \Zend\Db\Sql\Expression('count(*)')));
            $select->where('DATE(date_created) = DATE(NOW())');
        })->current();

        if($res->num >= self::PIN_REQUEST_DAILY_LIMIT) {
            throw new \Exception('sms limit exceeded', \Roaming\Helper\RespCodes::RESPONSE_STATUS_SMS_LIMIT_EXCEEDED);
        }
        
        if(!$user) {
            throw new \Exception('invlid user credinitioal');
        }
        
        $pin = $this->generatePin();
        
        //save pin
        if(!$this->mapper->updatePin($userIdentity, $pin)) {
            throw new \Exception('invlid user credinitioal');
        }
        
        try {
            $twilio = $this->getServiceLocator()->get('Twilio\Service\TwilioService');
//            $message = $twilio->account->messages->sendMessage(
//                $user->phone,
//                '+37491450266',
//                "Your pin is: " . $pin
//            );
            $pinRequestMapper->insert(array('user_id' => $user->id));
        
        } catch (\Exception $ex) {
            throw new \Exception('Error while sending sms',  \Roaming\Helper\RespCodes::RESPONSE_STATUS_TWILIO_MESSAGE_SENDING_EXCEPTION);
            //@TODO log error
        }
    }
    
    /**
     * @return \Roaming\DbMapper\PinRequest
     */
    protected function getPinRequestMapper() {
        return $this->getServiceLocator()->get('\Roaming\DbMapper\PinRequest');
    }
    /**
     * @return \Roaming\Model\Mor
     */
    protected function getMorModel() {
        return $this->getServiceLocator()->get('\Roaming\Model\Mor');
    }
    
}
