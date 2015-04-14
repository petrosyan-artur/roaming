//
//  cVaxSIPUserAgent.h
//  VaxPhone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class cVaxSIPUserAgentLibEx;

@interface cVaxSIPUserAgent : NSObject
{
    cVaxSIPUserAgentLibEx* mpVaxLibEx;
    
    Boolean m_bMuteSpk;
    Boolean m_bMuteMic;
    Boolean m_bDonotDisturb;

}

- (id) init;
- (void) dealloc;

- (Boolean) InitializeEx :(Boolean) bBindToListenIP :(NSString*) pListenIP :(int) nListenPort :(NSString*) pUserName :(NSString*) pLogin :(NSString*) pLoginPwd :(NSString*) pDisplayName :(NSString*) pDomainRealm :(NSString*) pSIPProxy :(NSString*) pSIPOutBoundProxy;

- (void) UnInitialize;

- (Boolean) RegisterToProxy :(int) nExpire;
- (Boolean) UnRegisterToProxy;

- (Boolean) DialCall :(NSString*) pDialNo;
- (Boolean) Connect :(NSString*) pToURI;

- (Boolean) Disconnect;

- (Boolean) AcceptCall :(NSString*) pCallId;
- (Boolean) RejectCall :(NSString*) pCallId;

- (Boolean) JoinTwoLine :(int) nLineNoB;
- (Boolean) TransferCallEx :(NSString*) pToUserName;
- (Boolean) TransferCall :(NSString*) pToURI;

- (Boolean) HoldLine;
- (Boolean) UnHoldLine;

- (Boolean) IsLineConnected;
- (Boolean) IsLineBusy;
- (Boolean) IsLineOpen;
- (Boolean) IsLineHold;

- (Boolean) OpenLine :(Boolean) bBindToRTPRxIP :(NSString*) pRTPRxIP :(int) nRTPRxPort;

- (Boolean) DigitDTMF :(int) nDigit;
- (Boolean) ForceInbandDTMF :(Boolean) bEnable;

- (void) DeselectAllVoiceCodec;
- (void) SelectAllVoiceCodec;
- (Boolean) SelectVoiceCodec :(int) nCodecNo;
- (Boolean) DeselectVoiceCodec :(int) nCodecNo;

- (Boolean) EnableKeepAlive :(int) nSeconds;
- (void) DisableKeepAlive;

- (Boolean) SetLicenceKey :(NSString*) pLicenceKey;
- (NSString*) GetMyIP;

- (int) GetVaxObjectError;

- (Boolean) MuteLineSPK :(Boolean) bEnable;
- (Boolean) MuteLineMIC :(Boolean) bEnable;

- (Boolean) MicSetSoftBoost :(Boolean) bEnable;
- (Boolean) MicGetSoftBoost;

- (Boolean) SpkSetSoftBoost :(Boolean) bEnable;
- (Boolean) SpkGetSoftBoost;

- (Boolean) MicSetAutoGain :(int) nValue;
- (int) MicGetAutoGain;

- (Boolean) SpkSetAutoGain :(int) nValue;
- (int) SpkGetAutoGain;

- (void) MuteSetMic :(Boolean) bEnable;
- (void) MuteSetSpk :(Boolean) bEnable;
- (Boolean) MuteGetMic;
- (Boolean) MuteGetSpk;

- (Boolean) VoiceChanger :(int) nPitch;

- (Boolean) SetEchoCancellation :(Boolean) bEnable;
- (Boolean) GetEchoCancellation;

- (Boolean) DonotDisturb :(Boolean) bEnable;
- (Boolean) BackgroundMode :(Boolean) bEnable;
- (Boolean) SpeakerPhone :(Boolean) bEnable;

- (Boolean) RecordStart :(NSString*) pFileName;
- (void) RecordStop;
- (void) RecordPause :(Boolean) bEnable;

- (Boolean) DiagnosticLog :(Boolean) bEnable;

- (void) ApplicationEnterForeground;
- (void) ApplicationEnterBackground;

- (Boolean) SetUserAgentSIP :(NSString*) pUserAgentName;
- (NSString*) GetUserAgentSIP;

- (Boolean) SetSubjectSDP :(NSString*) pSubjectSDP;
- (NSString*) GetSubjectSDP;

- (void) PostSendDataSIP :(char*) pData :(int) nDataSize :(char*) pToIP :(int) nToPort;
- (void) PostSendDataRTP :(int) nLineNo :(char*) pData :(int) nDataSize :(char*) pToIP :(int) nToPort;

- (void) PostRecvDataSIP :(char*) pData :(int) nDataSize;
- (void) PostRecvDataRTP :(int) nLineNo :(char*) pData :(int) nDataSize;

- (Boolean) CryptCOMM :(Boolean) bEnable :(NSString*) pRemoteIP :(int) nRemotePort;

////////////////////////////////////////////////
////////////////////////////////////////////////

- (void) OnSuccessToRegister;
- (void) OnSuccessToReRegister;
- (void) OnSuccessToUnRegister;

- (void) OnTryingToRegister;
- (void) OnTryingToReRegister;
- (void) OnTryingToUnRegister;

- (void) OnFailToRegister :(int) nStatusCode :(NSString*) pReasonPhrase;
- (void) OnFailToReRegister :(int) nStatusCode :(NSString*) pReasonPhrase;
- (void) OnFailToUnRegister :(int) nStatusCode :(NSString*) pReasonPhrase;

- (void) OnConnecting;
- (void) OnTryingToHold;
- (void) OnTryingToUnHold;
- (void) OnFailToHold;
- (void) OnFailToUnHold;
- (void) OnSuccessToHold;

- (void) OnSuccessToUnHold;
- (void) OnFailToConnect;
- (void) OnIncomingCall :(NSString*) pCallId :(NSString*) pDisplayName :(NSString*) pUserName;

- (void) OnIncomingCallRingingStart :(NSString*) pCallId;
- (void) OnIncomingCallRingingStop :(NSString*) pCallId;

- (void) OnConnected;

- (void) OnProvisionalResponse :(int) nStatusCode :(NSString*) pReasonPharase;
- (void) OnFailureResponse :(int) nStatusCode :(NSString*) pReasonPharase;

- (void) OnRedirectResponse :(int) nStatusCode :(NSString*) pReasonPharase :(NSString*) pContact;
- (void) OnDisconnectCall;

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
