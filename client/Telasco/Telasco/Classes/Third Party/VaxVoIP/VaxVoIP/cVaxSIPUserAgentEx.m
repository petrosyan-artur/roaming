//
//  VaxVoIP.m
//  Softphone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import "cVaxSIPUserAgentEx.h"
#import "NetWorkReach.h"
#import "cVaxSIPUserAgentAccount.h"
#import "cPlayDTMF.h"
#import "cVaxSIPUserAgentPhone.h"
#import "cVaxSettings.h"
#import "cAudioMedia.h"
#import "cAddressBook.h"
//#import "cAccountTableView.h"

static cVaxSIPUserAgentEx* m_pStaticVaxSIPUserAgentEx = NULL;

@implementation cVaxSIPUserAgentEx

+ (cVaxSIPUserAgentEx*) GetOBJ;
{
	return m_pStaticVaxSIPUserAgentEx;
}

- (void) VaxResetSettingAll;
{
    [mVaxSetting ResetSettingAll];
}

- (void) VaxLoadSettingAll;
{
    [mVaxSetting LoadSettingAll];
}

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

- (void) SetAccountTableView :(UITableViewController*) pView;
{
	[mVaxReg SetAccountTableView: pView];
}

- (void) SetPhoneDetailTableView :(UIViewController*) pView;
{
    [mVaxPhone SetDialpadView: pView];
    [mVaxReg SetPhoneDetailTableView: pView];
}

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

- (void) ErrorMessage;
{
    [cVaxGeneral ErrorMessage];
}

- (id) init;
{		
	self = [super init];
	
    m_bMuteSpk = false;
    m_bMuteMic = false;
    m_bDonotDisturb = false;
    
	m_pStaticVaxSIPUserAgentEx = self;
	
    m_nListenPortSIP = DEFAULT_LISTEN_PORT_SIP;
    m_nListenPortRTP = DEFAULT_LISTEN_PORT_RTP;
	
    mVaxReg = [cVaxSIPUserAgentAccount new];
    mVaxPhone = [cVaxSIPUserAgentPhone new];
    
    mPlayDTMF = [cPlayDTMF new];
    mVaxSetting = [cVaxSettings new];
    
    mCodecList = [NSMutableArray new];
    mLogFile = NULL;
    
    return self;
}

- (void) dealloc;
{	
	m_pStaticVaxSIPUserAgentEx = NULL;
	
    [mPlayDTMF release];
    
    [mVaxReg release];
    [mVaxPhone release];
    [mVaxSetting release];
    [mCodecList release];
    
    if(mLogFile)
        [mLogFile release];
     	
	[super dealloc];
}

+ (void) MessageBox :(NSString*) pMessage;
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"VaxPhone" message:pMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
	[alert show];
	[alert release];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (void) UnInitVaxVoIP;
{
	[mVaxPhone UnInitOBJ];
    [mVaxReg OnUnInitialize];
    
    [super UnInitialize];
}

- (Boolean) InitVaxVoIP :(NSString*) pUserName :(NSString*) pDisplayName :(NSString*) pAuthLogin :(NSString*) pAuthPwd :(NSString*) pDomainRealm :(NSString*) pProxySIP :(int)port;
{
	[self SetLicenceKey: @"TRIAL-LICENSE-KEY"];
    
    if(![NetWorkReach IsNetworkAvailable])
	{
        [self UnInitVaxVoIP];
        [mVaxReg OnInitialize];
        
        [super InitializeEx: FALSE: pProxySIP: port: pUserName: pDisplayName: @"": @"": pDomainRealm: pProxySIP: @""];
        [self BackgroundMode: true];
        
		return FALSE;
	}
	
	if([pUserName length] == 0 || [pAuthLogin length] == 0 || [pDisplayName length] == 0)
	{
		[cVaxSIPUserAgentEx MessageBox: @"Please enter the complete SIP account settings."];
		return FALSE;
	}
    
    [mVaxSetting LoadSettingAll];
    
	NSString* pMyIP = [super GetMyIP];
	
    [cVaxGeneral ResetRandomGenerator];
    
	Boolean bResult = TRUE;
    int nListenPort = m_nListenPortSIP;
    int nCount = 0;
	
	for(nCount = 0; nCount < 50; nCount++)
	{
		if(m_bChooseRandomlySIP)
            nListenPort = [cVaxGeneral CalcListenPort];
        
        if(![super InitializeEx: FALSE: pMyIP: nListenPort: pUserName: pAuthLogin: pAuthPwd: pDisplayName: pDomainRealm: pProxySIP: @""])
		{
			
			if([self GetVaxObjectError] != VAX_ERROR_COMMUNICATION_PORT_PROBLEM)
			{
				bResult = FALSE;
				
				[self ErrorMessage];
				break;
			}
		}
		else 
		{
			break;
		}
        
        if(nCount == 30)
        {
            [NSThread sleepForTimeInterval: 0.20];
            [cVaxGeneral ResetRandomGenerator];
        }

        nListenPort++;
	}
	
	if(nCount >= 50)
	{
		[cVaxSIPUserAgentEx MessageBox:@"Local SIP communication port is currently busy, please re-try!"];
		return FALSE;
	}

    [mVaxSetting LoadSettingAll];
    [mVaxPhone InitOBJ];
    [mVaxReg OnInitialize];
	
	return bResult;
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (Boolean) RegisterToProxySIP;
{
    [mVaxReg OnStartToRegister];
    AppDelegate *aDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    return [self RegisterToProxy:[aDelegate.telasco.port intValue]];
}

- (Boolean) VaxOpenLines;
{
    return [mVaxPhone OpenLine: m_bChooseRandomlyRTP];
}

- (int) GetPhoneStatus;
{
	return [mVaxPhone GetPhoneStatus];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (void) UpdateNetworkRTP :(Boolean) bChooseRandomly :(int) nListenPort;
{
    m_bChooseRandomlyRTP = bChooseRandomly;
    m_nListenPortRTP = nListenPort;
}

- (void) UpdateNetworkSIP :(Boolean) bChooseRandomly :(int) nListenPort;
{
    m_bChooseRandomlySIP = bChooseRandomly;
    m_nListenPortSIP = nListenPort;
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (Boolean) VaxGetMuteSpk;
{
    return [super MuteGetSpk];
}

- (void) VaxSetMuteSpk :(Boolean) bMute;
{
    [super MuteSetSpk: bMute];
}

- (Boolean) VaxGetMuteMic;
{
    return [super MuteGetMic];
}

- (void) VaxSetMuteMic :(Boolean) bMute;
{
    [super MuteSetMic: bMute];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (Boolean) VaxSetDonotDisturb :(Boolean) bEnable;
{
    m_bDonotDisturb = bEnable;
    return [super DonotDisturb: bEnable];
}

- (Boolean) VaxGetDonotDisturb;
{
    return m_bDonotDisturb;
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (void) UpdateCodec;
{
	[super DeselectAllVoiceCodec];
	
	for(int nCount = 0; nCount < mCodecList.count; nCount++)
        [super SelectVoiceCodec: [[mCodecList objectAtIndex: nCount] intValue]];
}

- (void) SetVoiceCodecs :(NSArray*) aCodecs;
{
    [mCodecList removeAllObjects];
    
    for(int nCount = 0; nCount < aCodecs.count; nCount++)
    {
        [mCodecList addObject: [aCodecs objectAtIndex: nCount]];
        //NSLog(@"%d\n", [[mCodecList objectAtIndex: nCount] intValue]);
    }
}

- (NSArray*) GetVoiceCodecs;
{
    return mCodecList;
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (Boolean) VaxDialCall :(NSString*) DialNo;
{
	[self UpdateCodec];
	return [mVaxPhone DialCall: DialNo];
}

- (Boolean) VaxAcceptCall;
{
	[self UpdateCodec];
	return [mVaxPhone AcceptCall];
}

- (Boolean) VaxRejectCall;
{
	return [mVaxPhone RejectCall];
}

- (void) VaxIgnoreCall;
{
    [mVaxPhone MuteIncomingCall];
}

- (void) VaxDisconnectCall;
{
    [mVaxPhone DisconnectCall];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (Boolean) VaxHoldCall;
{
	return [mVaxPhone HoldCall];
}

- (Boolean) VaxUnHoldCall;
{
	return [mVaxPhone UnHoldCall];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (void) SetListenPortSIP :(int) nPort;
{
    m_nListenPortSIP = nPort;
}

- (void) SetListenPortRTP :(int) nPort;
{
    m_nListenPortRTP = nPort;
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (Boolean) VaxTransferCall :(NSString*) pPhoneNo;
{
    if([pPhoneNo length] == 0)
    {
        return false;
    }
    
    pPhoneNo = [cAddressBook FilterPhoneNo: pPhoneNo];
    
    if(![super TransferCallEx: pPhoneNo])
    {
        [self ErrorMessage];
        return false;
    }
    
    return true;
}

- (Boolean) VaxJoinTwoLine :(int) nLineNoA :(int) nLineNoB;
{
    if(![super JoinTwoLine :nLineNoB])
    {
        return false;
    }
    
    return true;
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (Boolean) VaxSetEchoCancellation :(Boolean) bEnable;
{
    return [mVaxSetting SetAEC: bEnable];
}

- (Boolean) VaxGetEchoCancellation;
{
    return [mVaxSetting GetAEC];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (Boolean) VaxSetMicBoost :(Boolean) bEnable;
{
    return [mVaxSetting SetMicBoost: bEnable];
}

- (Boolean) VaxGetMicBoost;
{
    return [mVaxSetting GetMicBoost];
}

- (Boolean) VaxSetSpkBoost :(Boolean) bEnable;
{
    return [mVaxSetting SetSpkBoost: bEnable];
}

- (Boolean) VaxGetSpkBoost;
{
    return [mVaxSetting GetSpkBoost];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (Boolean) VaxMicSetAutoGain :(int) nValue;
{
    return [mVaxSetting MicSetAutoGain: nValue];
}

- (int) VaxMicGetAutoGain;
{
    return [mVaxSetting MicGetAutoGain];
}

- (Boolean) VaxSpkSetAutoGain :(int) nValue;
{
    return [mVaxSetting SpkSetAutoGain: nValue];
}

- (int) VaxSpkGetAutoGain;
{
    return [mVaxSetting SpkGetAutoGain];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (void) VaxSetVoiceCodecs :(NSArray*) aCodecNo :(NSArray*) aCodecState;
{
    [mVaxSetting SetVoiceCodec :aCodecNo :aCodecState];
}

- (void) VaxGetVoiceCodec :(NSMutableArray*) aCodecNo :(NSMutableArray*) aCodecState;
{
    [mVaxSetting GetVoiceCodec :aCodecNo :aCodecState];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (void) VaxSetVoiceChangerState :(Boolean) bEnable;
{
    [mVaxSetting SetVoiceChangerState: bEnable];
}

- (Boolean) VaxGetVoiceChangerState;
{
    return [mVaxSetting GetVoiceChangerState];
}

- (int) VaxGetVoiceChangerPitch;
{
    return [mVaxSetting GetVoiceChangerPitch];
}

- (Boolean) VaxSetVoiceChangerPitch :(int) nPitch;
{
    return [mVaxSetting SetVoiceChangerPitch: nPitch];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (Boolean) VaxSetMultiTask :(Boolean) bEnable;
{
    return [mVaxSetting SetMultiTask: bEnable];
}

- (Boolean) VaxGetMultiTask;
{
    return [mVaxSetting GetMultiTask];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (Boolean) VaxSetListenPortSIP :(Boolean) bChooseRandomly :(int) nListenPort;
{
    return [mVaxSetting SetListenPortSIP: bChooseRandomly: nListenPort];
}

- (void) VaxGetListenPortSIP :(Boolean*) pChooseRandomly :(int*) pListenPort;
{
    [mVaxSetting GetListenPortSIP: pChooseRandomly: pListenPort];
}

- (Boolean) VaxSetListenPortRTP :(Boolean) bChooseRandomly :(int) nListenPort;
{
    return [mVaxSetting SetListenPortRTP: bChooseRandomly: nListenPort];
}

- (void) VaxGetListenPortRTP :(Boolean*) pChooseRandomly :(int*) pListenPort;
{
    [mVaxSetting GetListenPortRTP: pChooseRandomly: pListenPort];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (void) VaxSetSpeakerPhoneState :(Boolean) bEnable;
{
    return [mVaxSetting SetSpeakerPhoneState: bEnable];
}

- (Boolean) VaxGetSpeakerPhoneState;
{
    return [mVaxSetting GetSpeakerPhoneState];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (Boolean) VaxDigitDTMF :(int) nDigit;
{
    if(!m_bMuteSpk)
        [mPlayDTMF PlayDTMF: nDigit];
    
    return [super DigitDTMF: nDigit];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (void) ApplyRingTone :(int) nRingToneId;
{
    [mVaxPhone SetRingTone: nRingToneId];
}

- (void) VaxSetRingTone :(int) nRingToneId;
{
    [mVaxSetting SetRingTone: nRingToneId];
}

- (int) VaxGetRingTone;
{
    return [mVaxSetting GetRingTone];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (Boolean) DiagnosticLog:(Boolean) bEnable;
{
    if(bEnable)
    {
        mLogFile = [NSMutableString new];
        [mLogFile setString: [cVaxGeneral GenCompleteFileName: @"VaxLog.txt"]];
    }
    else
    {
        if(mLogFile)
        {
            [mLogFile release];
            mLogFile = NULL;
        }
    }
    
    return [super DiagnosticLog: bEnable];
}

- (Boolean) VaxSetDiagnosticLog :(Boolean) bEnable;
{
    return [mVaxSetting SetDiagnosticLog: bEnable];
}

- (Boolean) VaxGetDiagnosticLog;
{
    return [mVaxSetting GetDiagnosticLog];
}

- (void) WriteToLogFile :(const char*) pText;
{
    int nDataSize = strlen(pText);
    
    FILE* fp = fopen([mLogFile UTF8String], "ab");
    
    fwrite(pText, sizeof(char), nDataSize, fp);
    fclose(fp);
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (Boolean) VaxGetCryptTunnel :(Boolean*) bEnable :(NSMutableString*) sTunnelServerIP :(int*) nTunnelServerPort;
{
    return [mVaxSetting GetCryptTunnel :bEnable :sTunnelServerIP :nTunnelServerPort];
}

- (Boolean) VaxSetCryptTunnel :(Boolean) bEnable :(NSString*) sTunnelServerIP :(int) nTunnelServerPort;
{
    return [mVaxSetting SetCryptTunnel :bEnable :sTunnelServerIP :nTunnelServerPort];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (void) OnSuccessToRegister;
{
    [mVaxReg OnSuccessToRegister];
}

- (void) OnSuccessToReRegister;
{
	[mVaxReg OnSuccessToReRegister];
}

- (void) OnSuccessToUnRegister;
{
	[mVaxReg OnSuccessToUnRegister];
}

- (void) OnTryingToRegister;
{
	[mVaxReg OnTryingToRegister];
}

- (void) OnTryingToReRegister;
{
	[mVaxReg OnTryingToReRegister];
}

- (void) OnTryingToUnRegister;
{
	[mVaxReg OnTryingToUnRegister];
}

- (void) OnFailToRegister :(int) nStatusCode :(NSString*) pReasonPhrase;
{
	[mVaxReg OnFailToRegister: nStatusCode: pReasonPhrase];
}

- (void) OnFailToReRegister :(int) nStatusCode :(NSString*) pReasonPhrase;
{
	[mVaxReg OnFailToReRegister: nStatusCode: pReasonPhrase];
}

- (void) OnFailToUnRegister :(int) nStatusCode :(NSString*) pReasonPhrase;
{
	[mVaxReg OnFailToUnRegister: nStatusCode: pReasonPhrase];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (void) OnConnecting;
{
	[mVaxPhone OnConnecting];
}

- (void) OnFailToConnect;
{
	[mVaxPhone OnFailToConnect];
}

- (void) OnConnected;
{
	[mVaxPhone OnConnected];
}

- (void) OnDisconnectCall;
{
	[mVaxPhone OnDisconnectCall];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (void) OnTryingToHold;
{
	[mVaxPhone OnTryingToHold];
}

- (void) OnTryingToUnHold;
{
	[mVaxPhone OnTryingToUnHold];
}

- (void) OnFailToHold;
{
	[mVaxPhone OnFailToHold];
}

- (void) OnFailToUnHold;
{
	[mVaxPhone OnFailToUnHold];
}

- (void) OnSuccessToHold;
{
	[mVaxPhone OnSuccessToHold];
}

- (void) OnSuccessToUnHold;
{
	[mVaxPhone OnSuccessToUnHold];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (void) OnIncomingCall :(NSString*) pCallId :(NSString*) pDisplayName :(NSString*) pUserName;
{
	[mVaxPhone OnIncomingCall: pCallId: pDisplayName: pUserName];
}

- (void) OnIncomingCallRingingStart :(NSString*) pCallId;
{
	[mVaxPhone OnIncomingCallRingingStart: pCallId];
}

- (void) OnIncomingCallRingingStop :(NSString*) pCallId;
{
	[mVaxPhone OnIncomingCallRingingStop: pCallId];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (void) OnProvisionalResponse :(int) nStatusCode :(NSString*) pReasonPharase;
{
	[mVaxPhone OnProvisionalResponse: nStatusCode: pReasonPharase];
}

- (void) OnFailureResponse :(int) nStatusCode :(NSString*) pReasonPharase;
{
	[mVaxPhone OnFailureResponse: nStatusCode: pReasonPharase];
}

- (void) OnRedirectResponse :(int) nStatusCode :(NSString*) pReasonPharase :(NSString*) pContact;
{
	[mVaxPhone OnRedirectResponse: nStatusCode: pReasonPharase: pContact];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (void) OnCallTransferAccepted;
{
	[mVaxPhone OnCallTransferAccepted];
}

- (void) OnFailToTransfer :(int) nStatusCode :(NSString*) pReasonPharase;
{
	[mVaxPhone OnFailToTransfer: nStatusCode: pReasonPharase];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (void) OnVaxNetworkReachability :(Boolean) bAvailable;
{
    [mVaxReg OnNetworkReachability: bAvailable];
}

- (Boolean) SetNetworkAutoRegister :(Boolean) bEnable;
{
    return [NetWorkReach SetNetworkReachability: bEnable];
}

- (Boolean) VaxSetNetworkAutoRegister :(Boolean) bEnable;
{
    return [mVaxSetting SetNetworkAutoRegister: bEnable];
}

- (Boolean) VaxGetNetworkAutoRegister;
{
    return [mVaxSetting GetNetworkAutoRegister];
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (void) OnIncomingDiagnostic :(NSString*) pMsgSIP :(NSString*) pFromIP :(int) nFromPort;
{
    NSString* pLogPacket = [NSString stringWithFormat: @"Received: %@:%d\n%@\n", pFromIP, nFromPort, pMsgSIP];
    [self WriteToLogFile: [pLogPacket UTF8String]];
}

- (void) OnOutgoingDiagnostic :(NSString*) pMsgSIP :(NSString*) pToIP :(int) nToPort;
{
    NSString* pLogPacket = [NSString stringWithFormat: @"Sent: %@:%d\n%@\n", pToIP, nToPort, pMsgSIP];
    [self WriteToLogFile: [pLogPacket UTF8String]];
}

- (void) OnVaxCaptureDevice;
{
    [[UIDevice currentDevice] setProximityMonitoringEnabled: YES];
    [cAudioMedia VaxCaptureMedia];
}

- (void) OnVaxReleaseDevice;
{
    [[UIDevice currentDevice] setProximityMonitoringEnabled: NO];
    [cAudioMedia VaxReleaseMedia];
}

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

- (void) OnSendDataSIP :(char*) pData :(int) nDataSize :(char*) pToIP :(int) nToPort;
{
    [super PostSendDataSIP :pData :nDataSize :pToIP :nToPort];
}

- (void) OnSendDataRTP :(int) nLineNo :(char*) pData :(int) nDataSize :(char*) pToIP :(int) nToPort;
{
    [super PostSendDataRTP :nLineNo :pData :nDataSize :pToIP :nToPort];
}

- (void) OnRecvDataSIP :(char*) pData :(int) nDataSize :(char*) pFromIP :(int)nFromPort;
{
    [super PostRecvDataSIP :pData :nDataSize];
}

- (void) OnRecvDataRTP :(int) nLineNo :(char*) pData :(int) nDataSize :(char*) pFromIP :(int)nFromPort;
{
    [super PostRecvDataRTP :nLineNo :pData :nDataSize];
}


@end
