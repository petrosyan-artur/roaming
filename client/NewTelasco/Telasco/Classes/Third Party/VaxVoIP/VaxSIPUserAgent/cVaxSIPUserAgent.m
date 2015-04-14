//
//  cVaxSIPUserAgent.m
//  VaxPhone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import "cVaxSIPUserAgent.h"
#import "cVaxSIPUserAgentLibEx.h"

@implementation cVaxSIPUserAgent

- (id) init;
{
	self = [super init];
    
    m_bMuteSpk = false;
    m_bMuteMic = false;
    m_bDonotDisturb = false;

    mpVaxLibEx = [[cVaxSIPUserAgentLibEx alloc] initWithVaxOBJ :self];
	return self;
}

- (void) dealloc;
{
    [mpVaxLibEx release];
    [super dealloc];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) InitializeEx :(Boolean) bBindToListenIP :(NSString*) pListenIP :(int) nListenPort :(NSString*) pUserName :(NSString*) pLogin :(NSString*) pLoginPwd :(NSString*) pDisplayName :(NSString*) pDomainRealm :(NSString*) pSIPProxy :(NSString*) pSIPOutBoundProxy;
{
    m_bMuteSpk = false;
    m_bMuteMic = false;
    m_bDonotDisturb = false;
    
    return [mpVaxLibEx InitializeEx :bBindToListenIP :pListenIP :nListenPort :pUserName :pLogin :pLoginPwd :pDisplayName :pDomainRealm :pSIPProxy :pSIPOutBoundProxy];
}

- (void) UnInitialize;
{
    [mpVaxLibEx UnInitialize];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) RegisterToProxy :(int) nExpire;
{
    return [mpVaxLibEx RegisterToProxy: nExpire];
}

- (Boolean) UnRegisterToProxy;
{
    return [mpVaxLibEx UnRegisterToProxy];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) DialCall :(NSString*) pDialNo;
{
    return [mpVaxLibEx DialCall: pDialNo];
}

- (Boolean) Connect :(NSString*) pToURI;
{
    return [mpVaxLibEx Connect: pToURI];
}

- (Boolean) Disconnect;
{
    return [mpVaxLibEx Disconnect];
}

- (Boolean) AcceptCall :(NSString*) pCallId;
{
    return [mpVaxLibEx AcceptCall :pCallId];
}

- (Boolean) RejectCall :(NSString*) pCallId;
{
    return [mpVaxLibEx RejectCall :pCallId];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) JoinTwoLine :(int) nLineNoB;
{
    return [mpVaxLibEx JoinTwoLine :nLineNoB];
}

- (Boolean) TransferCallEx :(NSString*) pToUserName;
{
    return [mpVaxLibEx TransferCallEx :pToUserName];
}

- (Boolean) TransferCall :(NSString*) pToURI;
{
    return [mpVaxLibEx TransferCall :pToURI];
}
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) HoldLine;
{
    return [mpVaxLibEx HoldLine];
}

- (Boolean) UnHoldLine;
{
    return [mpVaxLibEx UnHoldLine];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) IsLineConnected;
{
    return [mpVaxLibEx IsLineConnected];
}

- (Boolean) IsLineBusy;
{
    return [mpVaxLibEx IsLineBusy];
}

- (Boolean) IsLineOpen;
{
    return [mpVaxLibEx IsLineOpen];
}

- (Boolean) IsLineHold;
{
    return [mpVaxLibEx IsLineHold];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) OpenLine :(Boolean) bBindToRTPRxIP :(NSString*) pRTPRxIP :(int) nRTPRxPort;
{
    return [mpVaxLibEx OpenLine :bBindToRTPRxIP :pRTPRxIP :nRTPRxPort];
}

- (Boolean) DigitDTMF :(int) nDigit;
{
    return [mpVaxLibEx DigitDTMF :nDigit];
}

- (Boolean) ForceInbandDTMF :(Boolean) bEnable;
{
    return [mpVaxLibEx ForceInbandDTMF :bEnable];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) DeselectAllVoiceCodec;
{
    return [mpVaxLibEx DeselectAllVoiceCodec];
}

- (void) SelectAllVoiceCodec;
{
    return [mpVaxLibEx SelectAllVoiceCodec];
}

- (Boolean) SelectVoiceCodec :(int) nCodecNo;
{
    return [mpVaxLibEx SelectVoiceCodec :nCodecNo];
}

- (Boolean) DeselectVoiceCodec :(int) nCodecNo;
{
    return [mpVaxLibEx DeselectVoiceCodec :nCodecNo];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) EnableKeepAlive :(int) nSeconds;
{
    return [mpVaxLibEx EnableKeepAlive :nSeconds];
}

- (void) DisableKeepAlive;
{
    [mpVaxLibEx DisableKeepAlive];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) SetLicenceKey :(NSString*) pLicenceKey;
{
    return [mpVaxLibEx SetLicenceKey :pLicenceKey];
}

- (NSString*) GetMyIP;
{
    return [mpVaxLibEx GetMyIP];
}

- (int) GetVaxObjectError;
{
    return [mpVaxLibEx GetVaxObjectError];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) MuteLineSPK :(Boolean) bEnable;
{
    return [mpVaxLibEx MuteLineSPK :bEnable];
}

- (Boolean) MuteLineMIC :(Boolean) bEnable;
{
    return [mpVaxLibEx MuteLineMIC :bEnable];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) MicSetSoftBoost :(Boolean) bEnable;
{
    return [mpVaxLibEx MicSetSoftBoost :bEnable];
}

- (Boolean) MicGetSoftBoost;
{
    return [mpVaxLibEx MicGetSoftBoost];
}

- (Boolean) SpkSetSoftBoost :(Boolean) bEnable;
{
    return [mpVaxLibEx SpkSetSoftBoost :bEnable];
}

- (Boolean) SpkGetSoftBoost;
{
    return [mpVaxLibEx SpkGetSoftBoost];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) MicSetAutoGain :(int) nValue;
{
    return [mpVaxLibEx MicSetAutoGain :nValue];
}

- (int) MicGetAutoGain;
{
    return [mpVaxLibEx MicGetAutoGain];
}

- (Boolean) SpkSetAutoGain :(int) nValue;
{
    return [mpVaxLibEx SpkSetAutoGain :nValue];
}

- (int) SpkGetAutoGain;
{
    return [mpVaxLibEx SpkGetAutoGain];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) MuteSetMic :(Boolean) bEnable;
{
    m_bMuteMic = bEnable;
    [mpVaxLibEx MuteMic :bEnable];
}

- (void) MuteSetSpk :(Boolean) bEnable;
{
    m_bMuteSpk = bEnable;
    [mpVaxLibEx MuteSpk :bEnable];
}

- (Boolean) MuteGetMic;
{
    return m_bMuteMic;
}

- (Boolean) MuteGetSpk;
{
    return m_bMuteSpk;
}


////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) VoiceChanger :(int) nPitch;
{
    return [mpVaxLibEx VoiceChanger :nPitch];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) SetEchoCancellation :(Boolean) bEnable;
{
    return [mpVaxLibEx SetEchoCancellation :bEnable];
}

- (Boolean) GetEchoCancellation;
{
    return [mpVaxLibEx GetEchoCancellation];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) DonotDisturb :(Boolean) bEnable;
{
    return [mpVaxLibEx DonotDisturb :bEnable];
}

- (Boolean) BackgroundMode :(Boolean) bEnable;
{
    return [mpVaxLibEx BackgroundMode :bEnable];
}

- (Boolean) SpeakerPhone :(Boolean) bEnable;
{
    return [mpVaxLibEx SpeakerPhone :bEnable];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) RecordStart :(NSString*) pFileName;
{
    return [mpVaxLibEx RecordStart :pFileName];
}

- (void) RecordStop;
{
    return [mpVaxLibEx RecordStop];
}

- (void) RecordPause :(Boolean) bEnable;
{
    return [mpVaxLibEx RecordPause :bEnable];
}

- (Boolean) RecordTrvsSTART :(NSString*) pDirectoryPath;
{
    return [mpVaxLibEx RecordTrvsSTART :pDirectoryPath];
}

- (NSString*) RecordTrvsNEXT;
{
    return [mpVaxLibEx RecordTrvsNEXT];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) DiagnosticLog :(Boolean) bEnable;
{
    return [mpVaxLibEx DiagnosticLog :bEnable];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) ApplicationEnterForeground;
{
    return [mpVaxLibEx ApplicationEnterForeground];
}

- (void) ApplicationEnterBackground;
{
    return [mpVaxLibEx ApplicationEnterBackground];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) SetUserAgentSIP :(NSString*) pUserAgentName;
{
    return [mpVaxLibEx SetUserAgentSIP :pUserAgentName];
}

- (NSString*) GetUserAgentSIP;
{
    return [mpVaxLibEx GetUserAgentSIP];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) SetSubjectSDP :(NSString*) pSubjectSDP;
{
    return [mpVaxLibEx SetSubjectSDP :pSubjectSDP];
}

- (NSString*) GetSubjectSDP;
{
    return [mpVaxLibEx GetSubjectSDP];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) PostSendDataSIP :(char*) pData :(int) nDataSize :(char*) pToIP :(int) nToPort;
{
    [mpVaxLibEx PostSendDataSIP :pData :nDataSize :pToIP :nToPort];
}

- (void) PostSendDataRTP :(int) nLineNo :(char*) pData :(int) nDataSize :(char*) pToIP :(int) nToPort;
{
    [mpVaxLibEx PostSendDataRTP :nLineNo :pData :nDataSize :pToIP :nToPort];
}

- (void) PostRecvDataSIP :(char*) pData :(int) nDataSize;
{
    [mpVaxLibEx PostRecvDataSIP :pData :nDataSize];
}

- (void) PostRecvDataRTP :(int) nLineNo :(char*) pData :(int) nDataSize;
{
    [mpVaxLibEx PostRecvDataRTP :nLineNo :pData :nDataSize];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) CryptCOMM :(Boolean) bEnable :(NSString*) pRemoteIP :(int) nRemotePort;
{
    return [mpVaxLibEx CryptCOMM :bEnable :pRemoteIP :nRemotePort];
}

///////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) OnSuccessToRegister;
{
    
}

- (void) OnSuccessToReRegister;
{
    
}

- (void) OnSuccessToUnRegister;
{
    
}

- (void) OnTryingToRegister;
{
    
}

- (void) OnTryingToReRegister;
{
    
}

- (void) OnTryingToUnRegister;
{
    
}

- (void) OnFailToRegister :(int) nStatusCode :(NSString*) pReasonPhrase;
{
    
}

- (void) OnFailToReRegister :(int) nStatusCode :(NSString*) pReasonPhrase;
{
    
}

- (void) OnFailToUnRegister :(int) nStatusCode :(NSString*) pReasonPhrase;
{
    
}

- (void) OnConnecting;
{
    
}

- (void) OnTryingToHold;
{
    
}

- (void) OnTryingToUnHold;
{
    
}

- (void) OnFailToHold;
{
    
}

- (void) OnFailToUnHold;
{
    
}

- (void) OnSuccessToHold;
{
    
}

- (void) OnSuccessToUnHold;
{
    
}

- (void) OnFailToConnect;
{
    
}

- (void) OnIncomingCall :(NSString*) pCallId :(NSString*) pDisplayName :(NSString*) pUserName;
{
    
}

- (void) OnIncomingCallRingingStart :(NSString*) pCallId;
{
    
}

- (void) OnIncomingCallRingingStop :(NSString*) pCallId;
{
    
}

- (void) OnConnected;
{
    
}

- (void) OnProvisionalResponse :(int) nStatusCode :(NSString*) pReasonPharase;
{
    
}

- (void) OnFailureResponse :(int) nStatusCode :(NSString*) pReasonPharase;
{
    
}

- (void) OnRedirectResponse :(int) nStatusCode :(NSString*) pReasonPharase :(NSString*) pContact;
{
    
}

- (void) OnDisconnectCall;
{
    
}

- (void) OnCallTransferAccepted;
{
    
}

- (void) OnFailToTransfer :(int) nStatusCode :(NSString*) pReasonPharase;
{
    
}

- (void) OnIncomingDiagnostic :(NSString*) pMsgSIP :(NSString*) pFromIP :(int) nFromPort;
{
    
}

- (void) OnOutgoingDiagnostic :(NSString*) pMsgSIP :(NSString*) pToIP :(int) nToPort;
{
    
}

- (void) OnVaxCaptureDevice;
{
    
}

- (void) OnVaxReleaseDevice;
{
    
}

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

- (void) OnSendDataSIP :(char*) pData :(int) nDataSize :(char*) pToIP :(int) nToPort;
{
    
}

- (void) OnSendDataRTP :(int) nLineNo :(char*) pData :(int) nDataSize :(char*) pToIP :(int) nToPort;
{
    
}

- (void) OnRecvDataSIP :(char*) pData :(int) nDataSize :(char*) pFromIP :(int)nFromPort;
{
    
}

- (void) OnRecvDataRTP :(int) nLineNo :(char*) pData :(int) nDataSize :(char*) pFromIP :(int)nFromPort;
{
    
}



@end
