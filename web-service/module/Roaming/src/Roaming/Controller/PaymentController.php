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
            return $this->getJsonModel(\Roaming\Helper\RespCodes::RESPONSE_STATUS_OK);
        }
        
        $this->layout('layout/mobile');
        return;
    }
}