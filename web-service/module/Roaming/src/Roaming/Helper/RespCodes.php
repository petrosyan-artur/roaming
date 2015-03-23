<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

namespace Roaming\Helper;

/**
 * Description of RespCodes
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
class RespCodes {
    const RESPONSE_STATUS_OK = 1;
    const RESPONSE_STATUS_INVALID_PARAMETERS = 54621;
    const RESPONSE_STATUS_AUTH_ERROR = 54622;
    const RESPONSE_STATUS_SMS_LIMIT_EXCEEDED = 54623;
    const RESPONSE_STATUS_USER_ACTIVATION_ERROR = 54624;
    const RESPONSE_STATUS_ALREADY_LOGGED_IN = 54625;
    const RESPONSE_STATUS_LOIN_REQUIRED = 54626;
    const RESPONSE_STATUS_NOT_LOGGED_IN = 54627;
    const RESPONSE_STATUS_AUTH_ERROR_ACCOUNT_TEMPORARY_BLOCKED = 54628;
    const RESPONSE_STATUS_AUTH_ERROR_ACCOUNT_BLOCKED = 54629;
    const RESPONSE_STATUS_TWILIO_MESSAGE_SENDING_EXCEPTION = 54631;
    const RESPONSE_STATUS_INVALID_ADDRESS_LINE1 = 54640;
    const RESPONSE_STATUS_INVALID_ZIP_CODE = 54641;
    const RESPONSE_STATUS_INVALID_COUNTRY = 54643;
    const RESPONSE_STATUS_INVALID_CITY = 54644;
    const RESPONSE_STATUS_INVALID_STATE = 54645;
    const RESPONSE_STATUS_INVALID_CVC = 54646;
    const RESPONSE_STATUS_INVALID_EMAIL = 54647;
    const RESPONSE_STATUS_INVALID_REQUEST = 54691;
    const RESPONSE_STATUS_UNKNOWN_ERROR = 54699;
    const RESPONSE_NO_RATE_AVAILABLE = 54701;
    
    protected static $RESPCODES = array(
        self::RESPONSE_STATUS_OK => 'Ok',
        self::RESPONSE_STATUS_LOIN_REQUIRED => '',
        self::RESPONSE_STATUS_NOT_LOGGED_IN => '',
        self::RESPONSE_STATUS_ALREADY_LOGGED_IN => '',
        self::RESPONSE_STATUS_INVALID_PARAMETERS => '',
        self::RESPONSE_STATUS_INVALID_ADDRESS_LINE1 => '',
        self::RESPONSE_STATUS_INVALID_ZIP_CODE => '',
        self::RESPONSE_STATUS_INVALID_COUNTRY => '',
        self::RESPONSE_STATUS_INVALID_CITY => '',
        self::RESPONSE_STATUS_INVALID_STATE => '',
        self::RESPONSE_STATUS_INVALID_CVC => '',
        self::RESPONSE_STATUS_INVALID_EMAIL => '',
        self::RESPONSE_STATUS_AUTH_ERROR => 'Authentication error',
        self::RESPONSE_STATUS_SMS_LIMIT_EXCEEDED => 'SMS limit exceeded',
        self::RESPONSE_STATUS_AUTH_ERROR_ACCOUNT_TEMPORARY_BLOCKED => 'Your account temporary blocked, please try to login in 2 hours',
        self::RESPONSE_STATUS_AUTH_ERROR_ACCOUNT_BLOCKED => 'Your account blocked',
        self::RESPONSE_STATUS_TWILIO_MESSAGE_SENDING_EXCEPTION => '',
        self::RESPONSE_STATUS_INVALID_REQUEST => '',
        self::RESPONSE_STATUS_USER_ACTIVATION_ERROR => '',
        self::RESPONSE_STATUS_UNKNOWN_ERROR => 'unknown error',
        self::RESPONSE_NO_RATE_AVAILABLE => 'no rate available for specified location',
    );
    
    public static function getResponseMessage($code) {
        if(isset(self::$RESPCODES[$code])) {
            return self::$RESPCODES[$code];
        } else {
            return '';
        }
    }
    
    public static function checkRespCodeExist($code) {
        return array_key_exists($code, self::$RESPCODES);
    }
}
