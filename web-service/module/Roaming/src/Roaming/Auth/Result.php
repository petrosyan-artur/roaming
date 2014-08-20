<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

namespace Roaming\Auth;

/**
 * Description of Result
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
class Result extends \Zend\Authentication\Result {
            
    public function isValid() {
        return ((int) $this->code === \Roaming\Helper\RespCodes::RESPONSE_STATUS_OK) ? true : false;
    }
    
}
