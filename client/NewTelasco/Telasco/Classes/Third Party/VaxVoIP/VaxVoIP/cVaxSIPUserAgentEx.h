//
//  VaxVoIP.h
//  Softphone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import "cVaxSIPUserAgent.h"
#import "cVaxGeneral.h"
#import <AVFoundation/AVFoundation.h>

@class cVaxSIPUserAgentPhone;
@class cVaxSIPUserAgentAccount;
@class cPlayDTMF;
@class cVaxSettings;

@interface cVaxSIPUserAgentEx : cVaxSIPUserAgent
{
    cVaxSIPUserAgentAccount* mVaxReg;
    cVaxSIPUserAgentPhone* mVaxPhone;
    
    cPlayDTMF* mPlayDTMF;
    cVaxSettings* mVaxSetting;
    
    Boolean m_bChooseRandomlySIP;
    int m_nListenPortSIP;
    
    Boolean m_bChooseRandomlyRTP;
    int m_nListenPortRTP;
    
    NSMutableArray* mCodecList;
    NSMutableString* mLogFile;
}

- (id) init;
- (void) dealloc;

+ (cVaxSIPUserAgentEx*) GetOBJ;

- (void) VaxLoadSettingAll;

- (void) SetAccountTableView :(UITableViewController*) pView;
- (void) SetPhoneDetailTableView :(UIViewController*) pView;

+ (void) MessageBox :(NSString*) pMessage;
- (void) UpdateCodec;

- (void) UpdateNetworkSIP :(Boolean) bChooseRandomly :(int) nListenPort;
- (void) UpdateNetworkRTP :(Boolean) bChooseRandomly :(int) nListenPort;

- (void) UnInitVaxVoIP;
- (Boolean) InitVaxVoIP :(NSString*) pUserName :(NSString*) pDisplayName :(NSString*) pAuthLogin :(NSString*) pAuthPwd :(NSString*) pDomainRealm :(NSString*) pSIPProxy :(int)port;

- (Boolean) VaxOpenLines;
- (Boolean) RegisterToProxySIP;

- (Boolean) VaxDialCall :(NSString*) DialNo;
- (Boolean) VaxAcceptCall;
- (Boolean) VaxRejectCall;
- (void) VaxIgnoreCall;

- (void) VaxDisconnectCall;
- (Boolean) VaxHoldCall;
- (Boolean) VaxUnHoldCall;

- (int) GetPhoneStatus;
- (void) ErrorMessage;

- (void) SetListenPortSIP :(int) nPort;
- (void) SetListenPortRTP :(int) nPort;

- (void) SetVoiceCodecs :(NSArray*) aCodecs;
- (NSArray*) GetVoiceCodecs;

- (Boolean) VaxTransferCall :(NSString*) pPhoneNo;
- (Boolean) VaxJoinTwoLine :(int) nLineNoA :(int) nLineNoB;

- (Boolean) VaxGetMuteSpk;
- (Boolean) VaxGetMuteMic;

- (void) VaxSetMuteSpk :(Boolean) bMute;
- (void) VaxSetMuteMic :(Boolean) bMute;

- (Boolean) VaxSetEchoCancellation :(Boolean) bEnable;
- (Boolean) VaxGetEchoCancellation;

- (Boolean) VaxSetMicBoost :(Boolean) bEnable;
- (Boolean) VaxGetMicBoost;

- (Boolean) VaxSetSpkBoost :(Boolean) bEnable;
- (Boolean) VaxGetSpkBoost;

- (Boolean) VaxMicSetAutoGain :(int) nValue;
- (int) VaxMicGetAutoGain;

- (Boolean) VaxSetMultiTask :(Boolean) bEnable;
- (Boolean) VaxGetMultiTask;

- (Boolean) VaxSetDiagnosticLog :(Boolean) bEnable;
- (Boolean) VaxGetDiagnosticLog;

- (Boolean) VaxSpkSetAutoGain :(int) nValue;
- (int) VaxSpkGetAutoGain;

- (Boolean) VaxSetDonotDisturb :(Boolean) bEnable;
- (Boolean) VaxGetDonotDisturb;

- (void) VaxSetVoiceCodecs :(NSArray*) aCodecNo :(NSArray*) aCodecState;
- (void) VaxGetVoiceCodec :(NSMutableArray*) aCodecNo :(NSMutableArray*) aCodecState;

- (void) VaxSetVoiceChangerState :(Boolean) bEnable;
- (Boolean) VaxGetVoiceChangerState;
- (int) VaxGetVoiceChangerPitch;
- (Boolean) VaxSetVoiceChangerPitch :(int) nPitch;

- (Boolean) VaxSetListenPortSIP :(Boolean) bChooseRandomly :(int) nListenPort;
- (void) VaxGetListenPortSIP :(Boolean*) pChooseRandomly :(int*) pListenPort;

- (Boolean) VaxSetListenPortRTP :(Boolean) bChooseRandomly :(int) nListenPort;
- (void) VaxGetListenPortRTP :(Boolean*) pChooseRandomly :(int*) pListenPort;

- (void) VaxSetSpeakerPhoneState :(Boolean) bEnable;
- (Boolean) VaxGetSpeakerPhoneState;

- (void) VaxResetSettingAll;
- (Boolean) VaxDigitDTMF :(int) nDigit;

- (void) ApplyRingTone :(int) nRingToneId;
- (void) VaxSetRingTone :(int) nRingToneId;
- (int) VaxGetRingTone;

- (void) OnVaxNetworkReachability :(Boolean) bAvailable;
- (Boolean) SetNetworkAutoRegister :(Boolean) bEnable;
- (Boolean) VaxSetNetworkAutoRegister :(Boolean) bEnable;
- (Boolean) VaxGetNetworkAutoRegister;

- (Boolean) VaxGetCryptTunnel :(Boolean*) bEnable :(NSMutableString*) sTunnelServerIP :(int*) nTunnelServerPort;
- (Boolean) VaxSetCryptTunnel :(Boolean) bEnable :(NSString*) sTunnelServerIP :(int) nTunnelServerPort;

////////////////////////////////////
////////////////////////////////////

- (void) OnSuccessToRegister;
- (void) OnSuccessToReRegister;
- (void) OnSuccessToUnRegister;

- (void) OnTryingToRegister;
- (void) OnTryingToReRegister;
- (void) OnTryingToUnRegister;

- (void) OnFailToRegister :(int) nStatusCode :(NSString*) pReasonPhrase;
- (void) OnFailToReRegister :(int) nStatusCode :(NSString*) pReasonPhrase;
- (void) OnFailToUnRegister :(int) nStatusCode :(NSString*) pReasonPhrase;

- (void) OnTryingToHold;
- (void) OnTryingToUnHold;
- (void) OnFailToHold;
- (void) OnFailToUnHold;
- (void) OnSuccessToHold;
- (void) OnSuccessToUnHold;

- (void) OnIncomingCall :(NSString*) pCallId :(NSString*) pDisplayName :(NSString*) pUserName;
- (void) OnIncomingCallRingingStart :(NSString*) pCallId;
- (void) OnIncomingCallRingingStop :(NSString*) pCallId;

- (void) OnConnecting;
- (void) OnFailToConnect;
- (void) OnConnected;
- (void) OnDisconnectCall;

- (void) OnProvisionalResponse :(int) nStatusCode :(NSString*) pReasonPharase;
- (void) OnFailureResponse :(int) nStatusCode :(NSString*) pReasonPharase;
- (void) OnRedirectResponse :(int) nStatusCode :(NSString*) pReasonPharase :(NSString*) pContact;

- (void) OnCallTransferAccepted;
- (void) OnFailToTransfer :(int) nStatusCode :(NSString*) pReasonPharase;

- (void) OnIncomingDiagnostic :(NSString*) pMsgSIP :(NSString*) pFromIP :(int) nFromPort;
- (void) OnOutgoingDiagnostic :(NSString*) pMsgSIP :(NSString*) pToIP :(int) nToPort;

- (void) OnVaxCaptureDevice;
- (void) OnVaxReleaseDevice;

////////////////////////////////////////////////
////////////////////////////////////////////////

- (void) OnSendDataSIP :(char*) pData :(int) nDataSize :(char*) pToIP :(int) nToPort;
- (void) OnSendDataRTP :(int) nLineNo :(char*) pData :(int) nDataSize :(char*) pToIP :(int) nToPort;

- (void) OnRecvDataSIP :(char*) pData :(int) nDataSize :(char*) pFromIP :(int)nFromPort;
- (void) OnRecvDataRTP :(int) nLineNo :(char*) pData :(int) nDataSize :(char*) pFromIP :(int)nFromPort;


@end
