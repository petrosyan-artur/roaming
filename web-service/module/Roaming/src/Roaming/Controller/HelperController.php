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

class HelperController extends AbstractBaseController {
    
    public function countryListAction() {
        $request = $this->getRequest();

        $coutryListMapper = $this->getServiceLocator()->get('\Roaming\DbMapper\CountryList');
        $countries = $coutryListMapper->select('id <= 10')->toArray();
        $finalCountries = array();
        
        $serverHost = $this->getRequest()->getServer('HTTP_HOST');
        
        foreach ($countries as $country) {
            $c = array();
            $c['id'] = $country['id'];
            $c['name'] = $country['name'];
            $c['image_url'] = 'http://' . $serverHost . '/country/' . $country['id']. '.png';
            $finalCountries[] = $c;
        }
        
        return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_OK, $finalCountries);
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
    
}