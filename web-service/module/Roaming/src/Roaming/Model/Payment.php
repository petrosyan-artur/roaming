<?php

namespace Roaming\Model;

/**
 * Description of Payment
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */

class Payment extends AbstractBaseModel {
    
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
    public function createOrUpdateCustomer($user, $token) {
        $client = new \ZfrStripe\Client\StripeClient('sk_test_ThBNVSmFjQwxX2H2kuQCMdKJ');
        
        if($user->stripe_customer_id) {
            $client->deleteCustomer(
                array(
                    'card' => $user->stripe_customer_id,
                    'description' => $user->name . '@telasco.co.uk'
                )
            );
        }
        
        $customer = $client->createCustomer(
            array(
                'card' => $token,
                'description' => $user->name . '@telasco.co.uk'
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
            array(
                'stripe_customer_id' => $customer['id']
            ),
            array(
                'id = ?' => $user->id
            )
        );
        
        return $customer['id'];
    }
}