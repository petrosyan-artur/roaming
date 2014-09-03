<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

namespace Roaming\Controller;

/**
 * Description of PaymentController
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */

class PaymentController extends AbstractBaseController {
    
    public function addCardAction() {
        $request = $this->getRequest();
        
        if($request->isPost()) {
            $token = $request->getPost('token', false);
            $card = $request->getPost('card', false);
            $client = new \ZfrStripe\Client\StripeClient('sk_test_ThBNVSmFjQwxX2H2kuQCMdKJ');
            $customer = $client->createCustomer(
                array(
                    'card' => $token,
                    'description' => "payinguser@example.com"
                )
            );
            
            sleep(3);
            var_dump($customer);die;
            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_OK);
        }
        
        $coutryListMapper = $this->getServiceLocator()->get('\Roaming\DbMapper\CountryList');
        $countries = $coutryListMapper->select()->toArray();
        
        $this->layout('layout/mobile');
        return array('countries' => $countries);
    }
}