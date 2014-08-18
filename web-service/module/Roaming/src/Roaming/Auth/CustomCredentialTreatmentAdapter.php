<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

namespace Roaming\Auth;

/**
 * Description of CustomCredentialTreatmentAdapter
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
class CustomCredentialTreatmentAdapter extends \Zend\Authentication\Adapter\DbTable\CredentialTreatmentAdapter {
    protected function authenticateValidateResult($resultIdentity) {
        if ((int) $resultIdentity['status'] === \Roaming\DbMapper\User::STATUS_DELETED) {
            $this->authenticateResultInfo['code']       = \Zend\Authentication\Result::FAILURE_CREDENTIAL_INVALID;
            $this->authenticateResultInfo['messages'][] = 'Supplied credential is invalid.';
            return $this->authenticateCreateAuthResult();
        }
        
        return parent::authenticateValidateResult($resultIdentity);
    }
}
