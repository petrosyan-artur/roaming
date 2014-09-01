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

    
    /**
     *
     * @var \Roaming\Model\User
     */
    protected $userModel;
    
    public function __construct(\Roaming\Model\User $userModel,\Zend\Db\Adapter\Adapter $zendDb, $tableName = null, $identityColumn = null, $credentialColumn = null, $credentialTreatment = null) {
        $this->userModel = $userModel;
        parent::__construct($zendDb, $tableName, $identityColumn, $credentialColumn, $credentialTreatment);
    }
    
    protected function authenticateValidateResult($resultIdentity) {
        $userIdentity = $resultIdentity['name'];

        $userStatus = (int) $resultIdentity['status'];
        
        if ($resultIdentity['zend_auth_credential_match'] != '1' && 
                !in_array($userStatus, 
                         array(\Roaming\DbMapper\User::STATUS_TEMPORARY_BLOCKED, \Roaming\DbMapper\User::STATUS_DELETED))) {
            $this->authenticateResultInfo['code']       = \Roaming\Helper\RespCodes::RESPONSE_STATUS_AUTH_ERROR;
            $this->authenticateResultInfo['messages'][] = 'Supplied credential is invalid.';
            $this->getUserModel()->incrementFailLogin($userIdentity);
            return $this->authenticateCreateAuthResult();
        }
        
        if($this->tableName == 'user_pending') {
            //user is in temporary table and it is first success authentication, so lets move user to main DB
            $newIdentity = $this->getUserModel()->activate($userIdentity);
            if(is_null($newIdentity)) {
                $this->authenticateResultInfo['code']       = \Roaming\Helper\RespCodes::RESPONSE_STATUS_UNKNOWN_ERROR;
                $this->authenticateResultInfo['messages'][] = \Roaming\Helper\RespCodes::getResponseMessage(\Roaming\Helper\RespCodes::RESPONSE_STATUS_UNKNOWN_ERROR);
                return $this->authenticateCreateAuthResult();
            } else {
                $resultIdentity = (array) $newIdentity;
                $this->resultRow = $resultIdentity;
                $this->authenticateResultInfo['code']       = \Roaming\Helper\RespCodes::RESPONSE_STATUS_OK;
                $this->authenticateResultInfo['messages'][] = 'Authentication successful.';
                return $this->authenticateCreateAuthResult();
            }
        } else {
            switch ($userStatus) {
                case \Roaming\DbMapper\User::STATUS_ACTIVE:
                    unset($resultIdentity['zend_auth_credential_match']);
                    $this->resultRow = $resultIdentity;
                    $this->authenticateResultInfo['code']       = \Roaming\Helper\RespCodes::RESPONSE_STATUS_OK;
                    $this->authenticateResultInfo['messages'][] = 'Authentication successful.';
                    return $this->authenticateCreateAuthResult();
                case \Roaming\DbMapper\User::STATUS_TEMPORARY_BLOCKED:
                    $this->authenticateResultInfo['code'] = \Roaming\Helper\RespCodes::RESPONSE_STATUS_AUTH_ERROR_ACCOUNT_TEMPORARY_BLOCKED;
                    $this->authenticateResultInfo['messages'][] = 
                            \Roaming\Helper\RespCodes::getResponseMessage(\Roaming\Helper\RespCodes::RESPONSE_STATUS_AUTH_ERROR_ACCOUNT_TEMPORARY_BLOCKED);
                    return $this->authenticateCreateAuthResult();
                case \Roaming\DbMapper\User::STATUS_DELETED:
                default:
                    $this->authenticateResultInfo['code'] = \Roaming\Helper\RespCodes::RESPONSE_STATUS_AUTH_ERROR_ACCOUNT_BLOCKED;
                    $this->authenticateResultInfo['messages'][] = 
                            \Roaming\Helper\RespCodes::getResponseMessage(\Roaming\Helper\RespCodes::RESPONSE_STATUS_AUTH_ERROR_ACCOUNT_BLOCKED);
                    return $this->authenticateCreateAuthResult();
            }
        }
    }

    protected function authenticateValidateResultSet(array $resultIdentities) {
        $errorCode = \Roaming\Helper\RespCodes::RESPONSE_STATUS_AUTH_ERROR;
        if ((count($resultIdentities) < 1) || count($resultIdentities) > 1 && false === $this->getAmbiguityIdentity()) {
            $this->authenticateResultInfo['code']       = $errorCode;
            $this->authenticateResultInfo['messages'][] = \Roaming\Helper\RespCodes::getResponseMessage($errorCode);
            return $this->authenticateCreateAuthResult();
        }
        return true;
    }
    
    
    protected function authenticateCreateAuthResult() {
        return new Result(
            $this->authenticateResultInfo['code'],
            $this->authenticateResultInfo['identity'],
            $this->authenticateResultInfo['messages']
        );
    }
    
    /**
     * 
     * @return \Roaming\Model\User
     */
    protected function getUserModel() {
        return $this->userModel;
    }

}
