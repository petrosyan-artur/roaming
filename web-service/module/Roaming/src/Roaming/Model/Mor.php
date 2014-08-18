<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

namespace Roaming\Model;

/**
 * Description of Mor
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */

class Mor extends AbstractBaseModel {

    /**
     * 
     * @param type $phone
     * @return \Roaming\Entity\MorUserRegisterResponse
     */
    public function register($phone) {

        $email = "user_$phone@troaming.com";
        $username = "321$phone";
        $firstName = "$phone";
        $lastName = "$phone";
        $password = "AcbBfa$phone";
        
        $hashParams = array(
            'email' => $email,
            'id' => $this->getUniqueHash(),
            'device_type' => 'SIP',
            'username' => $username,
            'first_name' => $firstName,
            'last_name' => $lastName,
        );

        $a = '';

        foreach ($hashParams as $key => $value) {
            $a .= "&$key=$value";
        }

        $hash = $this->hash($hashParams);

        $notHashParams = array(
            'password' => $password,
            'password2' => $password,
            'country_id' => 1,
            'hash' => $hash,
        );

        $response = $this->apiCall('user_register', array_merge($hashParams, $notHashParams), \Zend\Http\Request::METHOD_POST);

        $ret = simplexml_load_string($response);

        if (isset($ret->status)) {
            $status = $ret->status;

            $registerResponce = new \Roaming\Entity\MorUserRegisterResponse();

            if (isset($status->success) && isset($ret->user_device_settings) && isset($ret->user_device_settings->user_id)) {
                $_tmp = (array) $ret->user_device_settings;
                
                $registerResponce->setStatus(\Roaming\Entity\MorUserRegisterResponse::STATUS_SUCCESS);
                $registerResponce->setMoreUserId($_tmp['user_id']);
                
                $deviceEntity = $registerResponce->getDeviceEntity();
                $deviceEntity->setAsteriskServerIp($_tmp['server_ip']);
                $deviceEntity->setId($_tmp['device_id']);
                $deviceEntity->setType($_tmp['device_type']);
                $deviceEntity->setPassword($_tmp['password']);
                $deviceEntity->setPin($_tmp['pin']);
                $deviceEntity->setUsername($_tmp['username']);
                $deviceEntity->setStatus(\Roaming\Entity\MorDevice::STATUS_ACTIVE);

//                $ret = $this->saveDeviceToLocalDb($deviceEntity, $morRegisterData['username']);

                //disable device, user should not have any device at registration , but mor creates by default
//                $this->disableDevice($deviceEntity->getId());
            } elseif (isset($status->error)) {
                $registerResponce->setStatus(\Roaming\Entity\MorUserRegisterResponse::STATUS_FAILD);
            } else {
                $registerResponce->setStatus(\Roaming\Entity\MorUserRegisterResponse::STATUS_FAILD);
            }
        } else {
            $registerResponce->setStatus(\Roaming\Entity\MorUserRegisterResponse::STATUS_FAILD);
        }

        return $registerResponce;
    }

    protected function apiCall($action, $params, $method = \Zend\Http\Request::METHOD_POST) {
        
        $url = $this->getBaseUrl() . "api/$action";
        
        $request = new \Zend\Http\Request();
        $client = new \Zend\Http\Client($url);
        $client->setEncType(\Zend\Http\Client::ENC_FORMDATA);
        
        // Performing a POST request
        $request->setUri($url);
        $request->setMethod($method);
        if($method === \Zend\Http\Request::METHOD_POST) {
            $request->getPost()->fromArray($params);
        } else {
            $request->getQuery()->fromArray($params);
        }
        $response = $client->dispatch($request);
        return $response->getContent();
    }
    
    protected function hash(array $params) {
        $tbh = '';
        foreach ($params as $value) {
            $tbh .= $value;
        }
        
        $tbh .= $this->getApiSec();
        return sha1($tbh);
    }
    
    public function getUniqueHash() {
        return $this->uniqueHash;
    }

    public function getApiSec() {
        return $this->apiSec;
    }

    public function setUniqueHash($uniqueHash) {
        $this->uniqueHash = $uniqueHash;
    }

    public function setApiSec($apiSec) {
        $this->apiSec = $apiSec;
    }

    
    public function getBaseUrl() {
        return $this->baseUrl;
    }

    public function setBaseUrl($baseUrl) {
        $this->baseUrl = $baseUrl;
    }
    
    public function getServerIP() {
        return $this->serverIP;
    }

    public function setServerIP($serverIP) {
        $this->serverIP = $serverIP;
    }
}
