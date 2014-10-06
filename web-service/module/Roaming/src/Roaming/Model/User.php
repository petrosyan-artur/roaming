<?php

namespace Roaming\Model;

/**
 * Description of User
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
class User extends AbstractBaseModel {
    
    const PIN_REQUEST_DAILY_LIMIT = 10;
    
    const MAX_LOGIN_ATTEMPTS = 3;
    
    /**
     *
     * @var \Roaming\DbMapper\User
     */
    protected $mapper;
    /**
     *
     * @var \Roaming\DbMapper\PendingUser
     */
    protected $pendingUserMapper;
    
    public function __construct(\Roaming\DbMapper\User $mapper, \Zend\ServiceManager\ServiceLocatorInterface $sm) {
        parent::__construct($sm);
        $this->setPendingUserMapper($sm->get('\Roaming\DbMapper\PendingUser'));
        $this->mapper = $mapper;
    }
    
    public static function handleTemporaryBlockedUsers() {
//        $mapper = 
    }
        
    public function getUsers() {
        return $this->mapper->select();
    }
    
    protected function generatePin() {
//        return mt_rand(10000, 99999);
        return '1111';
    }

    public function registered($phone) {
        $user = $this->mapper->getUserByIdentity($phone);
        if(!$user) {
            //check in pending users
            $user = $this->getPendingUserMapper()->select(array('name=?' => array($phone)))->current();
        }
        return !!$user;
    }
    
    public function register($phone) {
        $user = $this->mapper->getUserByIdentity($phone);
        if($user) {
            return;
        }
        return $this->getPendingUserMapper()->insert(array('name' => $phone));
    }
    
    protected function generateSipPassword() {
        $specialCharacters = str_shuffle('$%*&#@');
        $charactersUP = str_shuffle('ABSDEFGHIGKLMNOPQRSTUVWXYZ');
        $charactersDOWN = str_shuffle('abcdefghigklmnopqrstuvwxyz');
        $numbers = str_shuffle('0123456789');
        
        $password = '';
        
        $nmbSpecialCharacters = rand(4, 7);
        $nmbCharactersUP = rand(4, 7);
        $nmbCharactersDOWN = rand(4, 7);
        $nmbNumbers = rand(4, 7);
        
        for($i=0; $i<$nmbSpecialCharacters; $i++) {
            $password .= $this->getRandomCharacter($specialCharacters);
        }
        
        for($i=0; $i<$nmbCharactersUP; $i++) {
            $password .= $this->getRandomCharacter($charactersUP);
        }
        
        for($i=0; $i<$nmbCharactersDOWN; $i++) {
            $password .= $this->getRandomCharacter($charactersDOWN);
        }
        
        for($i=0; $i<$nmbNumbers; $i++) {
            $password .= $this->getRandomCharacter($numbers);
        }
        
        $password = str_shuffle($password);
        
        return $password;
        
    }
    
    private function getRandomCharacter($set) {
        return substr($set, rand(0, strlen($set)), 1);
    }
    
    /**
     * 
     * @param type $user
     * @return \Roaming\DbMapper\User | null 
     */
    public function activate($userCredinitial) {
        $pendingUser = $this->getPendingUserMapper()->select(array('name=?' => array($userCredinitial)))->current();
        
        if($pendingUser && $pendingUser->status != \Roaming\DbMapper\PendingUser::STATUS_DELETED) {
            $sipPassword = $this->generateSipPassword();
            $this->getMapper()->insert(
                array(
                    'name' => $userCredinitial,
                    'username' => $userCredinitial,
                    'cli_number' => $userCredinitial,
                    'pin' => $pendingUser->pin,
                    'status' => \Roaming\DbMapper\User::STATUS_ACTIVE,
                    'secret' =>$sipPassword,
                    'rate_sheet_id' => 1,
                    'country_id' => 1
                )
            );
            
            $this->getPendingUserMapper()->
                    update(array('status' => \Roaming\DbMapper\PendingUser::STATUS_DELETED), array('name=?' => $userCredinitial));
            
            return $this->mapper->select(array('name = ?' => $userCredinitial))->current();
            
        }

        return null;
    }
    
    public function updateTemporaryBlocked() {
        
    }
    
    public function incrementFailLogin($phone) {
        $this->mapper->incrementFailLogin($phone);
        $changedUserData = $this->mapper->select(array('phone=?' => $phone))->current();
        if($changedUserData->login_failure >= self::MAX_LOGIN_ATTEMPTS) {
            $this->mapper->update(array('status' => \Roaming\DbMapper\User::STATUS_TEMPORARY_BLOCKED), array('phone=?' => $phone));
        }
    }
    
    public function isUserPending($userIdentity) {
        $pendingUserMapper = $this->getPendingUserMapper();
        $userMapper = $this->mapper;
        $pendingUser = $pendingUserMapper->select(array('status = ?' => \Roaming\DbMapper\PendingUser::STATUS_ACTIVE, 'name=?' => $userIdentity))->current();
        if($pendingUser) {
            $_u = $userMapper->select(array('name = ?' => $userIdentity))->current();
            if($_u) {
                throw new Exception('User is pending but exists in used db');
            }
        }
        
        return !!$pendingUser;
    }
    
    public function generateAndSendPin($userIdentity) {        
        
        $pendingUserMapper = $this->getPendingUserMapper();
        $userMapper = $this->mapper;
        $user = null;
        $userIsPending = false;
        
        $pendingUser = $pendingUserMapper->select(array('status=?' => \Roaming\DbMapper\PendingUser::STATUS_ACTIVE, 'name=?' => $userIdentity))->current();
        if($pendingUser) {
            //user not activated yet, lets make assert user not exist in user db
            $_u = $userMapper->select(array('name = ?' => $userIdentity))->current();
            if($_u) {
                throw new Exception('User is pending but exists in used db');
            }
            $user = $pendingUser;
            $userIsPending = true;
        } else {
            $user = $userMapper->getUserByIdentity($userIdentity);
        }
        
        if(!$user) {
            throw new Exception('There is no such user');
        }
        
        $pinRequestMapper = $this->getPinRequestMapper();
        
        $select = new \Zend\Db\Sql\Select($this->getPinRequestMapper()->getTable());
        $select->columns(array('num' => new \Zend\Db\Sql\Expression('count(*)')));
        $select->where('DATE(date_created) = DATE(NOW())');
        $select->where(array('name = ?' => array($userIdentity)));
        
        $res = $this->getPinRequestMapper()->selectWith($select)->current();

        if($res->num >= self::PIN_REQUEST_DAILY_LIMIT) {
            throw new \Exception('sms limit exceeded', \Roaming\Helper\RespCodes::RESPONSE_STATUS_SMS_LIMIT_EXCEEDED);
        }
        
        
        $pin = $this->generatePin();
        
        //save pin
        if($userIsPending) {
            $pendingUserMapper->updatePin($userIdentity, $pin);
        } else {
            $userMapper->updatePin($userIdentity, $pin);
        }
        
        try {
            $twilio = $this->getServiceLocator()->get('Twilio\Service\TwilioService');
//            $message = $twilio->account->messages->sendMessage(
//                $user->name,
//                '+37491450266',
//                "Your pin is: " . $pin
//            );
            $pinRequestMapper->insert(array('name' => $userIdentity));
        
        } catch (\Exception $ex) {
            throw new \Exception('Error while sending sms',  \Roaming\Helper\RespCodes::RESPONSE_STATUS_TWILIO_MESSAGE_SENDING_EXCEPTION);
            //@TODO log error
        }
    }
    
    public function updateClientLoginData(/*$device_token,*/ $client_version, $userIdentity) {
        $this->mapper->update(
            array(
//                  'device_token' => $device_token,
                'client_version' => $client_version,
            ),
            array('name' => $userIdentity)
        );
    }
    
//    public function 
    
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
    
    public function getMapper() {
        return $this->mapper;
    }
    
    /**
     * 
     * @return \Roaming\DbMapper\PendingUser
     */
    public function getPendingUserMapper() {
        return $this->pendingUserMapper;
    }

    /**
     * 
     * @param \Roaming\DbMapper\PendingUser $pendingUserMapper
     */
    public function setPendingUserMapper(\Roaming\DbMapper\PendingUser $pendingUserMapper) {
        $this->pendingUserMapper = $pendingUserMapper;
    }


    
}
