<?php

namespace Roaming\Model;
use Zend\Db\Sql\Select;

/**
 * Description of Rate
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */

class Rate extends AbstractBaseModel {

    const NO_RATE_FOR_SPECIFIED_NUMBER = -1;

    public function __construct(\Zend\ServiceManager\ServiceLocatorInterface $sm) {
        parent::__construct($sm);
    }    

    /**
     * 
     * @param type $user
     * @param type $token
     * @return null | varchar
     * @throws \Exception
     */
    public function createOrUpdateCustomer($user, $token, $email, $auto_recharge) {
        $client = new \ZfrStripe\Client\StripeClient('sk_test_ThBNVSmFjQwxX2H2kuQCMdKJ');
        
        if($user->stripe_customer_id) {
            $client->deleteCustomer(
                array(
                    'id' => $user->stripe_customer_id,
                )
            );
        }
        
        $customer = $client->createCustomer(
            array(
                'card' => $token,
                'description' => $email
            )
        );
        
        if(sizeof($cards = $customer['cards']['data']) !== 1) {
            return null;
        }
        
        $card = $customer['cards']['data'][0];
        if($card['country'] !== $card['address_country']) {
            throw new \Exception('Invalid country', \Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_COUNTRY);
        }
        if($card['cvc_check'] !== 'pass') {
            throw new \Exception('Invalid cvc', \Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_CVC);
        }
        if($card['address_zip_check'] !== 'pass') {
            throw new \Exception('Invalid zip', \Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_ZIP_CODE);
        }
//        if($card['address_line1_check'] !== 'pass') {
//            throw new \Exception('Invalid address', \Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_ADDRESS_LINE1);
//        }
        
        $this->getServiceLocator()->get('\Roaming\DbMapper\User')->update(

        );
        
        return $customer['id'];
    }

    public function checkRate($phoneNumbers, $userId) {

        $rates = array();
        foreach ($phoneNumbers as $phoneNumber) {

            $rate = $this->getServiceLocator()->get('\Roaming\DbMapper\Rate')->getRate($phoneNumber, $userId);
            if(is_null($rate)) {
                $rate = self::NO_RATE_FOR_SPECIFIED_NUMBER;
            }
            $phoneNumber = " " . $phoneNumber;
            $rates[$phoneNumber] = $rate;
        }


        return $rates;
    }

    public function changeSettings($autoRecharge, $userCredinitial) {
        $this->getServiceLocator()->get('\Roaming\DbMapper\User')->
                    update(array('auto_recharge' => $autoRecharge), array('name=?' => $userCredinitial));
    }
    
}