//
//  cVaxGeneral.h
//  VaxPhone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VAX_REG_STATUS_ONLINE               0
#define VAX_REG_STATUS_OFFLINE              1
#define VAX_REG_STATUS_TRYING               2
#define VAX_REG_STATUS_FAILED               3
#define VAX_REG_STATUS_SUCCESS              4
#define VAX_REG_STATUS_NETWORK_NOT_FOUND    5

#define VAX_REREG_STATUS_TRYING             6
#define VAX_REREG_STATUS_FAILED             7
#define VAX_REREG_STATUS_SUCCESS            8

#define VAX_UNREG_STATUS_TRYING             9
#define VAX_UNREG_STATUS_FAILED             10
#define VAX_UNREG_STATUS_SUCCESS            11


//////////////////////////////////////////////

#define VAX_LINE_STATUS_FREE		0
#define VAX_LINE_STATUS_CONNECTED	1
#define VAX_LINE_STATUS_INCOMING	2
#define VAX_LINE_STATUS_CONNECTING	3
#define VAX_LINE_STATUS_HOLD		4

#define DEFAULT_LISTEN_PORT_SIP     5060
#define DEFAULT_LISTEN_PORT_RTP     7850

#define VAX_CODEC_G711U             0
#define VAX_CODEC_G711A             1
#define VAX_CODEC_GSM610            2
#define VAX_CODEC_ILBC              3
#define VAX_CODEC_OPUS              4

#define VAX_TOTAL_NO_CODECS         5

//////////////////////////////////////////////////

#define VAX_RING_TONE_1985_RING         1
#define VAX_RING_TONE_ELEGANT           2
#define VAX_RING_TONE_MAGICAL           3
#define VAX_RING_TONE_OFFICE_I_PHONE    4
#define VAX_RING_TONE_OFFICE_PHONE      5

//////////////////////////////////////////////////

#define VAX_VOICE_CHANGER_GRANDPA_DRUNK      4
#define VAX_VOICE_CHANGER_TEEN_BOY           8
#define VAX_VOICE_CHANGER_HOUSE_HOLD_REBOT   12
#define VAX_VOICE_CHANGER_HELIUM_INHALED     16
#define VAX_VOICE_CHANGER_CHIPMUNK           20

//////////////////////////////////////////////////

#define VAX_ERROR_INITIALIZE_VAXOBJECT				10
#define VAX_ERROR_COMMUNICATION_PORT_PROBLEM		11
#define VAX_ERROR_INVALID_LICENSE_KEY				12
#define VAX_ERROR_TASK_MANAGER_INITIALIZATION		13

#define VAX_ERROR_INPUT_DEVICE_PROBLEM				14
#define VAX_ERROR_OUTPUT_DEVICE_PROBLEM				15

#define VAX_ERROR_INPUT_DEVICE_NOT_OPEN				16
#define VAX_ERROR_OUTPUT_DEVICE_NOT_OPEN			17

#define VAX_ERROR_INPUT_DEVICE_VOLUME_PROBLEM		18
#define VAX_ERROR_OUTPUT_DEVICE_VOLUME_PROBLEM		19

#define VAX_ERROR_RECORDING_MEDIA_INIT_FAIL			20
#define VAX_ERROR_WAVEFILE_OPEN_FAIL				21

#define VAX_ERROR_INVALID_SIP_URI					22
#define VAX_ERROR_CODEC_NOT_SUPPORTED				23
#define VAX_ERROR_TO_CREATE_SDP						24
#define VAX_ERROR_TO_CREATE_INVITE_REQUEST			25
#define VAX_ERROR_TO_CREATE_REGISTER_REQUEST		26
#define VAX_ERROR_TO_CREATE_UNREGISTER_REQUEST		27
#define VAX_ERROR_TO_CREATE_BYE_REQUEST				28

#define VAX_ERROR_INVALID_LINE_NO					29
#define VAX_ERROR_LINE_ALREADY_BUSY					30
#define VAX_ERROR_LINE_NOT_OPEN						31
#define VAX_ERROR_INVALID_CALL_ID					32

#define VAX_ERROR_INVALID_VALUE						33
#define VAX_ERROR_NOT_IN_VOICE_SESSION				34

#define VAX_ERROR_WAVEFILE_READ_FAIL				35
#define VAX_ERROR_WAVEFILE_WRITE_FAIL				36
#define VAX_ERROR_WAVEFILE_INVALID_FORMAT			37

#define VAX_ERROR_TO_CREATE_CANCEL_REQUEST			38
#define VAX_ERROR_LICENSE_KEY_LIMIT_EXCEEDED		39

#define ERROR_TO_FIND_PROXY_IN_SERVER_KEY			40

@interface cVaxGeneral : NSObject
{
    
}

+ (void) ResetRandomGenerator;
+ (int) CalcListenPort;
+ (void) ErrorMessage;

+ (NSString *) GenCompleteFileName :(NSString*) pFileName;
+ (Boolean) IsFileExist :(NSString*) pFileName;
+ (Boolean) DeleteFile :(NSString*) pFileName;

+ (Boolean) IsiOS7orAbove;

@end
