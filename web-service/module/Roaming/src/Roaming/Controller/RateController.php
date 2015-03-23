<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

namespace Roaming\Controller;

/**
 * Description of RateController
 *
 * @auth    or Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */

class RateController extends AbstractBaseController {
    
    public function getAction() {
        $request = $this->getRequest();
        


        if ($request->isPost()) {
            $user = $this->getLoggedinUser();
            var_dump($user);die;
            if(is_null($user)) {

                return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_NOT_LOGGED_IN);

            }

            $phoneNumber = $request->getPost('phone', false);

            if(!$phoneNumber) {
                return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_PARAMETERS, array(), array("No phone number provided"));
            } elseif(!is_numeric($phoneNumber)) {
                return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_PARAMETERS, array(), array("Invalid phone number, only numbers accepted"));
            }

            $rateModel = $this->RateModel();
            try {
                $rate = $rateModel->checkRate($phoneNumber, $user['name']);
            } catch(Exception $ex) {
                return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_UNKNOWN_ERROR, array(), array());
            }
            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_OK,
                array(
                    'rate' => $rate
                ), array());
        } else {
            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_REQUEST, array(), array());
        }

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
    
    /**
     * 
     * @return \Roaming\Model\Rate
     */
    protected function RateModel() {
        return $this->getServiceLocator()->get('\Roaming\Model\Rate');
    }
    
}