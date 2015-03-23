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

            if(!$user) {

                return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_NOT_LOGGED_IN);

            }

            $phoneNumbers = $request->getPost('phones', false);

            if(!$phoneNumbers || !is_array($phoneNumbers)) {
                return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_PARAMETERS, array(), array("No phone number provided"));
            }

            foreach ($phoneNumbers as $key => $phoneNumber) {
                $phoneNumber = preg_replace('/\s+/', '', $phoneNumber);
                $phoneNumber = preg_replace('~\x{00a0}~siu', '', $phoneNumber);
                error_log($phoneNumber);
                if(!is_numeric($phoneNumber)) {
                    return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_PARAMETERS, array(), array("Invalid phone number, only numbers accepted"));
                }
                $phoneNumbers[$key] = $phoneNumber;
            }


            $rateModel = $this->RateModel();
            try {
                $rates = $rateModel->checkRate($phoneNumbers, $user['name']);
            } catch(Exception $ex) {
                return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_UNKNOWN_ERROR, array(), array());
            }
            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_OK,
                array(
                    'rates' => $rates
                ), array());
        } else {
            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_INVALID_REQUEST, array(), array());
        }

    }

    /**
     * 
     * @return \Roaming\Model\Rate
     */
    protected function RateModel() {
        return $this->getServiceLocator()->get('\Roaming\Model\Rate');
    }
    
}