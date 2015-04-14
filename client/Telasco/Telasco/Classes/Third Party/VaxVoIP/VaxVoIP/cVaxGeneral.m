//
//  cVaxGeneral.m
//  VaxPhone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import "cVaxGeneral.h"
#import "cVaxSIPUserAgentEx.h"

static Boolean m_bRandomChooseListenPort = false;

#define RTP_PORT_RANGE_MIN  1024
#define RTP_PORT_RANGE_MAX  9580

@implementation cVaxGeneral

+ (void) ResetRandomGenerator;
{
    srandom([[NSDate date] timeIntervalSince1970]);
    m_bRandomChooseListenPort = false;
}

+ (int) CalcListenPort;
{
    if(m_bRandomChooseListenPort == false)
    {
        m_bRandomChooseListenPort = true;
        srandom([[NSDate date] timeIntervalSince1970]);
    }
    
    int nListenPort = 0;

    while(TRUE)
    {
        nListenPort = ((uint) random() % (RTP_PORT_RANGE_MAX/2)) * 2;
        
        if(nListenPort < RTP_PORT_RANGE_MIN || nListenPort > RTP_PORT_RANGE_MAX)
        {
            continue;
        }
        
        break;
    }
    
    //NSLog(@"ListenP: %d\n", nListenPort);
    
    return nListenPort;
}


+ (void) ErrorMessage;
{
	int nVaxObjectError = [[cVaxSIPUserAgentEx GetOBJ] GetVaxObjectError];
    
	switch (nVaxObjectError)
	{
		case VAX_ERROR_INITIALIZE_VAXOBJECT:
			[cVaxSIPUserAgentEx MessageBox: @"Please make your SIP Account online first!"];
			break;
            
		case VAX_ERROR_COMMUNICATION_PORT_PROBLEM:
			[cVaxSIPUserAgentEx MessageBox: @"Local communication port is currently busy, please re-try!"];
			break;
            
		case VAX_ERROR_INVALID_LICENSE_KEY:
			[cVaxSIPUserAgentEx MessageBox: @"License Key is invalid!"];
			break;
            
		case VAX_ERROR_TASK_MANAGER_INITIALIZATION:
			[cVaxSIPUserAgentEx MessageBox: @"Failed to initialize task manager, please re-try!"];
			break;
            
		case VAX_ERROR_INPUT_DEVICE_PROBLEM:
			[cVaxSIPUserAgentEx MessageBox: @"Unable to access sound input device, please re-try!"];
			break;
            
		case VAX_ERROR_OUTPUT_DEVICE_PROBLEM:
			[cVaxSIPUserAgentEx MessageBox: @"Unable to access sound output device, please re-try!"];
			break;
            
		case VAX_ERROR_INPUT_DEVICE_NOT_OPEN:
			[cVaxSIPUserAgentEx MessageBox: @"Unable to access sound input device, please re-try!"];
			break;
            
		case VAX_ERROR_OUTPUT_DEVICE_NOT_OPEN:
			[cVaxSIPUserAgentEx MessageBox: @"Unable to access sound output device, please re-try!"];
			break;
            
		case VAX_ERROR_INPUT_DEVICE_VOLUME_PROBLEM:
			[cVaxSIPUserAgentEx MessageBox: @"Your sound device does not support Mic volume"];
			break;
            
		case VAX_ERROR_OUTPUT_DEVICE_VOLUME_PROBLEM:
			[cVaxSIPUserAgentEx MessageBox: @"Your sound device does not support Speaker volume"];
			break;
            
		case VAX_ERROR_RECORDING_MEDIA_INIT_FAIL:
			[cVaxSIPUserAgentEx MessageBox: @"Recording media initialization failed!"];
			break;
            
		case VAX_ERROR_WAVEFILE_OPEN_FAIL:
			[cVaxSIPUserAgentEx MessageBox: @"Unable to initialize recording process"];
			break;
            
		case VAX_ERROR_INVALID_SIP_URI:
			[cVaxSIPUserAgentEx MessageBox: @"Provided SIP URI is invalid"];
			break;
            
		case VAX_ERROR_CODEC_NOT_SUPPORTED:
			[cVaxSIPUserAgentEx MessageBox: @"Selected Voice Codec is not supported!"];
			break;
            
		case VAX_ERROR_TO_CREATE_SDP:
			[cVaxSIPUserAgentEx MessageBox: @"Error to create SDP Packet, please re-try!"];
			break;
            
		case VAX_ERROR_TO_CREATE_INVITE_REQUEST:
			[cVaxSIPUserAgentEx MessageBox: @"Error to create SIP CONNECTION Packet, please re-try!"];
			break;
            
		case VAX_ERROR_TO_CREATE_REGISTER_REQUEST:
			[cVaxSIPUserAgentEx MessageBox: @"Error to create SIP REGISTER Packet, please re-try!"];
			break;
            
		case VAX_ERROR_TO_CREATE_UNREGISTER_REQUEST:
			[cVaxSIPUserAgentEx MessageBox: @"Error to create SIP UN-REGISTER Packet, please re-try!"];
			break;
            
		case VAX_ERROR_TO_CREATE_BYE_REQUEST:
			[cVaxSIPUserAgentEx MessageBox: @"Error to create SIP DISCONNECT Packet, please re-try!"];
			break;
            
		case VAX_ERROR_INVALID_LINE_NO:
			[cVaxSIPUserAgentEx MessageBox: @"Selected Phone-Line is invalid!"];
			break;
            
		case VAX_ERROR_LINE_ALREADY_BUSY:
			[cVaxSIPUserAgentEx MessageBox: @"Selected Phone-Line is currently busy!"];
			break;
            
		case VAX_ERROR_LINE_NOT_OPEN:
			[cVaxSIPUserAgentEx MessageBox: @"Selected Phone-Line is not ready to use!"];
			break;
            
		case VAX_ERROR_INVALID_CALL_ID:
			[cVaxSIPUserAgentEx MessageBox: @"Invalid Call-ID!"];
			break;
			
		case VAX_ERROR_INVALID_VALUE:
			[cVaxSIPUserAgentEx MessageBox: @"Invalid argument(s)!"];
			break;
			
		case VAX_ERROR_NOT_IN_VOICE_SESSION:
			[cVaxSIPUserAgentEx MessageBox: @"Selected line is not in Voice Session!"];
			break;
			
		case VAX_ERROR_WAVEFILE_READ_FAIL:
			[cVaxSIPUserAgentEx MessageBox: @"Failed to read sound file"];
			break;
			
		case VAX_ERROR_WAVEFILE_WRITE_FAIL:
			[cVaxSIPUserAgentEx MessageBox: @"Failed to write sound file"];
			break;
			
		case VAX_ERROR_WAVEFILE_INVALID_FORMAT:
			[cVaxSIPUserAgentEx MessageBox: @"Unsupported sound file format"];
			break;
			
		case VAX_ERROR_TO_CREATE_CANCEL_REQUEST:
			[cVaxSIPUserAgentEx MessageBox: @"Error to create SIP CANCEL Packet, please re-try!"];
			break;
			
		case VAX_ERROR_LICENSE_KEY_LIMIT_EXCEEDED:
			[cVaxSIPUserAgentEx MessageBox: @"License limit exceeded"];
			break;
            
        case ERROR_TO_FIND_PROXY_IN_SERVER_KEY:
            [cVaxSIPUserAgentEx MessageBox: @"Provided Proxy SIP not found in the SERVER KEY."];
			break;
	}
}

+ (NSString *) GetDirectoryPath;
{    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex: 0];
}

+ (NSString *) GenCompleteFileName :(NSString*) pFileName;
{
    return [[self GetDirectoryPath] stringByAppendingPathComponent: pFileName];
}

+ (Boolean) IsFileExist :(NSString*) pFileName;
{
    return [[NSFileManager defaultManager] fileExistsAtPath: pFileName];
}

+ (Boolean) DeleteFile :(NSString*) pFileName;
{
    return [[NSFileManager defaultManager] removeItemAtPath: pFileName error:NULL];
}

+ (Boolean) IsiOS7orAbove;
{
    NSString* sVer = [[UIDevice currentDevice] systemVersion];
    
    if([sVer floatValue] >= 7.0)
        return true;
    
    return false;
}


@end
