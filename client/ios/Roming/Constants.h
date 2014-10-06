//
//  Constants.h
//  Roming
//
//  Created by Karen Ghandilyan on 8/23/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#ifndef Roming_Constants_h
#define Roming_Constants_h

#define BASE_URL @"http://37.48.84.64"


typedef enum {
    RESPONSE_STATUS_OK = 1,                                         // (Ok status)
    RESPONSE_STATUS_INVALID_PARAMETERS = 54621,                     // (invalid request parameters)
    RESPONSE_STATUS_AUTH_ERROR = 54622,                             // (invalid credinitials combination)
    RESPONSE_STATUS_SMS_LIMIT_EXCEEDED = 54623,                     // (daily sms limit exceeded)
    RESPONSE_STATUS_ALREADY_LOGGED_IN = 54625,                      // (user already logged in)
    RESPONSE_STATUS_LOIN_REQUIRED = 54626,                          // (login required)
    RESPONSE_STATUS_AUTH_ERROR_ACCOUNT_TEMPORARY_BLOCKED = 54628,   // (authentication error and user temporary blocked)
    RESPONSE_STATUS_TWILIO_MESSAGE_SENDING_EXCEPTION = 54631,       // (sms sending failure)
    RESPONSE_STATUS_INVALID_REQUEST = 54691,                        // (invalid request type)
    RESPONSE_STATUS_UNKNOWN_ERROR = 54699                           // (unknown error)


} ResponseStatus;


#define USER_REQUESTED_PERMISIONS @"user_requested_permisions"
#define SIP_CONNECTION_DETAILS @"sip_connections_detailss"

#define PUSH_NOTIFICATION_REQUSTED @"push_notification_requested"
#endif
