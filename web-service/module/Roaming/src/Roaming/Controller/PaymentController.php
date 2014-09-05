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
        
//        if(!$this->getAuthService()->hasIdentity()) {
//            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_LOIN_REQUIRED);
//        }
        
        if($request->isPost()) {
            $token = $request->getPost('token', false);
            $email = $request->getPost('email', false);
//            $card = $request->getPost('card', false);
            
            $paymentModel = $this->getPaymentModel();
            $user = $this->getLoggedinUser();
            
            try {
                $stripe_customer_id = $paymentModel->createOrUpdateCustomer($user, $token);
                if(!is_null($stripe_customer_id)) {
                    return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_UNKNOWN_ERROR, array(), array());
                }
//                $paymentModel->upda
            } catch (Exception $exc) {
                $code = $exc->getCode();
                if(!\Roaming\Helper\RespCodes::checkRespCodeExist($code)) {
                    $code = \Roaming\Helper\RespCodes::RESPONSE_STATUS_UNKNOWN_ERROR;
                }
                return $this->getJsonModel($code, array(), array($exc->getMessage()));
            }
        
//            sleep(3);
            var_dump($customer);die;
            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_OK);
        }
        
        $coutryListMapper = $this->getServiceLocator()->get('\Roaming\DbMapper\CountryList');
        $countries = $coutryListMapper->select()->toArray();
        $viewModel = new \Zend\View\Model\ViewModel();
        $viewModel->setVariables(array('countries' => $countries))
                  ->setTerminal(true);

        return $viewModel;
    }
    
    public function indexAction() {
        $this->layout('layout/mobile');
    }
    
    
    /**
     * 
     * @return \Roaming\Model\Payment
     */
    protected function getPaymentModel() {
        return $this->getServiceLocator()->get('\Roaming\Model\Payment');
    }
    
}