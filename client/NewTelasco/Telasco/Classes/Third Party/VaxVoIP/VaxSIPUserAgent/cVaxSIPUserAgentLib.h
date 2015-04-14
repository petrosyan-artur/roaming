//
//  cVaxSIPUserAgentLib.h
//  VaxVoIP SIP iOS SDK
//
//  Modified by VaxSoft [www.vaxvoip.com] on 02.FEB.2015
//  Copyright 2015 VaxSoft. All rights reserved.
//

@class cVaxSIPUserAgentObject;

@interface cVaxSIPUserAgentLib : NSObject 
{
	cVaxSIPUserAgentObject* m_pVaxMainObj;
}

- (id) init;
- (void) dealloc;

- (Boolean) InitializeEx :(Boolean) bBindToListenIP :(NSString*) pListenIP :(int) nListenPort :(NSString*) pUserName :(NSString*) pLogin :(NSString*) pLoginPwd :(NSString*) pDisplayName :(NSString*) pDomainRealm :(NSString*) pSIPProxy :(NSString*) pSIPOutBoundProxy :(int) nTotalLine;

- (Boolean) InitializeEx :(Boolean) bBindToListenIP :(NSString*) pListenIP :(int) nListenPort :(NSString*) pUserName :(NSString*) pLogin :(NSString*) pLoginPwd :(NSString*) pDisplayName :(NSString*) pDomainRealm :(NSString*) pSIPProxyIP :(int) nSIPProxyPort :(NSString*) pSIPOutBoundProxyIP :(int) nSIPOutBoundProxyPort :(int) nTotalLine;

- (Boolean) Initialize :(Boolean) bBindToListenIP :(NSString*) pListenIP :(int) nListenPort :(NSString*) pFromURI :(NSString*) pSIPOutBoundProxy :(NSString*) pSIPProxy :(NSString*) pLoginId :(NSString*) pLoginPwd :(int) nTotalLine;

- (void) UnInitialize;

- (Boolean) RegisterToProxy :(int) nExpire;
- (Boolean) UnRegisterToProxy;

- (Boolean) DialCall :(int) nLineNo :(NSString*) pDialNo :(int) nInputDeviceId :(int) nOutputDeviceId;
- (Boolean) Connect :(int) nLineNo :(NSString*) pToURI :(int) nInputDeviceId :(int) nOutputDeviceId;

- (Boolean) Disconnect :(int) nLineNo;

- (Boolean) AcceptCall :(int) nLineNo :(NSString*) pCallId :(int) nInputDeviceId :(int) nOutputDeviceId;
- (Boolean) RejectCall :(NSString*) pCallId;

- (Boolean) JoinTwoLine :(int) nLineNoA :(int) nLineNoB;
- (Boolean) TransferCallEx :(int) nLineNo :(NSString*) pToUserName;
- (Boolean) TransferCall :(int) nLineNo :(NSString*) pToURI;

- (Boolean) HoldLine :(int) nLineNo;
- (Boolean) UnHoldLine :(int) nLineNo;

- (Boolean) IsLineConnected :(int) nLineNo;
- (Boolean) IsLineBusy :(int) nLineNo;
- (Boolean) IsLineOpen :(int) nLineNo;
- (Boolean) IsLineHold :(int) nLineNo;

- (Boolean) OpenLine :(int) nLineNo :(Boolean) bBindToRTPRxIP :(NSString*) pRTPRxIP :(int) nRTPRxPort;
- (Boolean) DigitDTMF :(int) nLineNo :(int) nDigit;

- (void) DeselectAllVoiceCodec;
- (void) SelectAllVoiceCodec;
- (Boolean) SelectVoiceCodec :(int) nCodecNo;
- (Boolean) DeselectVoiceCodec :(int) nCodecNo;

- (Boolean) EnableKeepAlive :(int) nSeconds;
- (void) DisableKeepAlive;

- (Boolean) SetLicenceKey :(NSString*) pLicenceKey;
- (NSString*) GetMyIP;

- (int) GetVaxObjectError;

- (Boolean) MuteLineSPK :(int) nLineNo :(Boolean) bEnable;
- (Boolean) MuteLineMIC :(int) nLineNo :(Boolean) bEnable;

- (Boolean) MicSetSoftBoost :(Boolean) bEnable;
- (Boolean) MicGetSoftBoost;

- (Boolean) SpkSetSoftBoost :(Boolean) bEnable;
- (Boolean) SpkGetSoftBoost;

- (Boolean) MicSetAutoGain :(int) nValue;
- (int) MicGetAutoGain;

- (Boolean) SpkSetAutoGain :(int) nValue;
- (int) SpkGetAutoGain;

- (void) MuteMic :(Boolean) bEnable;
- (void) MuteSpk :(Boolean) bEnable;

- (Boolean) VoiceChanger :(int) nPitch;

- (Boolean) SetEchoCancellation :(Boolean) bEnable;
- (Boolean) GetEchoCancellation;

- (Boolean) DonotDisturb :(Boolean) bEnable;
- (Boolean) BackgroundMode :(Boolean) bEnable;
- (Boolean) SpeakerPhone :(Boolean) bEnable;

- (Boolean) RecordStart :(NSString*) pFileName;
- (void) RecordStop;
- (void) RecordPause :(Boolean) bEnable;

- (Boolean) RecordTrvsSTART :(NSString*) pDirectoryPath;
- (NSString*) RecordTrvsNEXT;

- (Boolean) PlayWaveMemOpen :(char*) pFileMem :(uint) nSizeData;
- (Boolean) PlayWaveMemStart :(Boolean) bLoopPlay;
- (Boolean) PlayWaveMemStop;
- (Boolean) PlayWaveMemVolume :(int) nVolume;
- (Boolean) PlayWaveMemPause :(Boolean) bPause;
- (void) PlayWaveMemClose;

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

- (int) GetJitterCountPacketTotal :(int) nLineNo;
- (int) GetJitterCountPacketLost :(int) nLineNo;
- (int) GetJitterSizeBuffer :(int) nLineNo;

- (Boolean) AccessDataSIP :(Boolean) bEnable;
- (Boolean) AccessDataRTP :(int) nLineNo :(Boolean) bEnable;

- (Boolean) ForceInbandDTMF :(int) nLineNo :(Boolean) bEnable;

- (Boolean) ChatAddContact :(NSString*) pUserName;
- (Boolean) ChatRemoveContact :(NSString*) pUserName;
- (Boolean) ChatSetMyStatus :(int) nStatusId;
- (Boolean) ChatSendMessageText :(NSString*) pUserName :(NSString*) pMsgText :(int) nMsgType :(int) nUserValue32bit;
- (Boolean) ChatSendMessageTyping :(NSString*) pUserName :(int) nUserValue32bit;

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

- (void) OnConnecting :(int) nLineNo;
- (void) OnTryingToHold :(int) nLineNo;
- (void) OnTryingToUnHold :(int) nLineNo;
- (void) OnFailToHold :(int) nLineNo;
- (void) OnFailToUnHold :(int) nLineNo;
- (void) OnSuccessToHold :(int) nLineNo;

- (void) OnSuccessToUnHold :(int) nLineNo;
- (void) OnFailToConnect :(int) nLineNo;
- (void) OnIncomingCall :(NSString*) pCallId :(NSString*) pDisplayName :(NSString*) pUserName :(NSString*) pFromURI :(NSString*) pToURI;

- (void) OnIncomingCallRingingStart :(NSString*) pCallId;
- (void) OnIncomingCallRingingStop :(NSString*) pCallId;

- (void) OnConnected :(int) nLineNo :(NSString*) pTxRTPIP :(int) nTxRTPPort :(NSString*) pCallId;

- (void) OnProvisionalResponse :(int) nLineNo :(int) nStatusCode :(NSString*) pReasonPharase;
- (void) OnFailureResponse :(int) nLineNo :(int) nStatusCode :(NSString*) pReasonPharase;

- (void) OnRedirectResponse :(int) nLineNo :(int) nStatusCode :(NSString*) pReasonPharase :(NSString*) pContact;
- (void) OnDisconnectCall :(int) nLineNo;

- (void) OnCallTransferAccepted :(int) nLineNo;
- (void) OnFailToTransfer :(int) nLineNo :(int) nStatusCode :(NSString*) pReasonPharase;

- (void) OnIncomingDiagnostic :(NSString*) pMsgSIP :(NSString*) pFromIP :(int) nFromPort;
- (void) OnOutgoingDiagnostic :(NSString*) pMsgSIP :(NSString*) pToIP :(int) nToPort;

- (void) OnVaxCaptureDevice;
- (void) OnVaxReleaseDevice;

- (void) OnDigitDTMF :(int) nLineNo :(int) nDigit;

- (void) OnHoldCall :(int) nLineNo;
- (void) OnUnHoldCall :(int) nLineNo;

- (void) OnSendDataSIP :(char*) pData :(int) nDataSize :(char*) pToIP :(int) nToPort;
- (void) OnSendDataRTP :(int) nLineNo :(char*) pData :(int) nDataSize :(char*) pToIP :(int) nToPort;

- (void) OnRecvDataSIP :(char*) pData :(int) nDataSize :(char*) pFromIP :(int)nFromPort;
- (void) OnRecvDataRTP :(int) nLineNo :(char*) pData :(int) nDataSize :(char*) pFromIP :(int)nFromPort;

- (void) OnChatContactStatus :(NSString*) pUserName :(int) nStatusId;
- (void) OnChatSendMsgTextSuccess :(NSString*) pUserName :(NSString*) pMsgText :(int) nUserValue32bit;
- (void) OnChatSendMsgTextFail :(NSString*) pUserName :(int) nStatusCode :(NSString*) pReasonPhrase :(NSString*) pMsgText :(int) nUserValue32bit;
- (void) OnChatSendMsgTypingSuccess :(NSString*) pUserName :(int) nUserValue32bit;
- (void) OnChatSendMsgTypingFail :(NSString*) pUserName :(int) nStatusCode :(NSString*) pReasonPhrase :(int) nUserValue32bit;
- (void) OnChatRecvMsgText :(NSString*) pUserName :(NSString*) pMsgText;
- (void) OnChatRecvMsgTypingStart :(NSString*) pUserName;
- (void) OnChatRecvMsgTypingStop :(NSString*) pUserName;

@end
