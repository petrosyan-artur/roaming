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
 * @auth    or Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */

class PaymentController extends AbstractBaseController {
    
    public function addCardAction() {
        $request = $this->getRequest();
        
        $user = $this->getLoggedinUser();
//        if(!$user) {
//            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_LOIN_REQUIRED);
//        }
        
        if($request->isPost()) {
            $token = $request->getPost('token', false);
            $email = $request->getPost('email', false);
            $auto_recharge = $request->getPost('auto_recharge', false);
            
            if(!$token) {
                return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_UNKNOWN_ERROR, array(), array());
            } elseif(!$email) {
                return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_EMAIL, array(), array());
            }
            
            $paymentModel = $this->getPaymentModel();
            
            
            try {
                $stripe_customer_id = $paymentModel->createOrUpdateCustomer($user, $token, $email, $auto_recharge);
                if(is_null($stripe_customer_id)) {
                    return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_UNKNOWN_ERROR, array(), array());
                }
            } catch (\Exception $exc) {
                $code = $exc->getCode();
                if(!\Roaming\Helper\RespCodes::checkRespCodeExist($code)) {
                    $code = \Roaming\Helper\RespCodes::RESPONSE_STATUS_UNKNOWN_ERROR;
                }
                return $this->getJsonModel($code, array(), array($exc->getMessage()));
            }
        
            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_OK);
        }
        
        $coutryListMapper = $this->getServiceLocator()->get('\Roaming\DbMapper\CountryList');
        $countries = $coutryListMapper->select()->toArray();
        
        $this->layout('layout/mobile');
        return array('countries' => $countries, 'stripe_customer_id' =>$user->stripe_customer_id,
                    'auto_recharge' => $user->auto_recharge);
//        
//        $viewModel = new \Zend\View\Model\ViewModel();
//        $viewModel->setVariables(array('countries' => $countries))
//                  ->setTerminal(true);
//
//        return $viewModel;
    }
    
    public function settingsAction() {
        $request = $this->getRequest();
        
        $user = $this->getLoggedinUser();
        if(!$user) {
            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_LOIN_REQUIRED);
        }
        
        if($request->isPost()) {
            $autoRecharge = $request->getPost('auto_recharge', null);
            if(is_null($autoRecharge)) {
                return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_PARAMETERS, array(), array());
            }
            
            $this->getPaymentModel()->changeSettings($autoRecharge, $this->getLoogedinUserIdentity());
            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_OK, array(), array());
        }
        
        return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_REQUEST, array(), array());
    }
    
    public function indexAction() {
        $this->layout('layout/mobile');
    }

    
    public function testAction() {
        $this->layout('layout/mobile');
    }
    
    /**
     * 
     * @return \Roaming\Model\Payment
     */
    protected function getPaymentModel() {
        return $this->getServiceLocator()->get('\Roaming\Model\Payment');
    }

    public function buySubscriptionAction() {

    }
    
}