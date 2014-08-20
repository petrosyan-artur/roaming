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
        $userIdentity = $resultIdentity['phone'];
        
        if ($resultIdentity['zend_auth_credential_match'] != '1') {
            $this->authenticateResultInfo['code']       = \Roaming\Helper\RespCodes::RESPONSE_STATUS_AUTH_ERROR;
            $this->authenticateResultInfo['messages'][] = 'Supplied credential is invalid.';
            $this->getUserModel()->incrementFailLogin($userIdentity);
            return $this->authenticateCreateAuthResult();
        }

        $userStatus = (int) $resultIdentity['status'];
        
        switch ($userStatus) {
            case \Roaming\DbMapper\User::STATUS_PENDING:
                $newIdentity = $this->getUserModel()->activate($userIdentity);
                if(is_null($newIdentity)) {
                    $this->authenticateResultInfo['code']       = \Roaming\Helper\RespCodes::RESPONSE_STATUS_UNKNOWN_ERROR;
                    $this->authenticateResultInfo['messages'][] = 'Authentication problem.';
                    return $this->authenticateCreateAuthResult();
                }
                $resultIdentity = (array) $newIdentity;
            case \Roaming\DbMapper\User::STATUS_ACTIVE:
                unset($resultIdentity['zend_auth_credential_match']);
                $this->resultRow = $resultIdentity;
                $this->authenticateResultInfo['code']       = \Roaming\Helper\RespCodes::RESPONSE_STATUS_OK;
                $this->authenticateResultInfo['messages'][] = 'Authentication successful.';
                return $this->authenticateCreateAuthResult();
            case \Roaming\DbMapper\User::STATUS_TEMPORARY_BLOCKED:
                $this->authenticateResultInfo['code'] = \Roaming\Helper\RespCodes::RESPONSE_STATUS_AUTH_ERROR_ACCOUNT_TEMPORARY_BLOCKED;
                $this->authenticateResultInfo['messages'][] = 'Your account temporary blocked, please try to login in 2 hours';
                return $this->authenticateCreateAuthResult();
            case \Roaming\DbMapper\User::STATUS_DELETED:
            default:
                $this->authenticateResultInfo['code'] = \Zend\Authentication\Result::RESPONSE_STATUS_AUTH_ERROR_ACCOUNT_BLOCKED;
                $this->authenticateResultInfo['messages'][] = 'Your account blocked, contact support';
                return $this->authenticateCreateAuthResult();
        }
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
