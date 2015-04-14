//
//  cVaxSIPUserAgentLibEx.m
//  VaxPhone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import "cVaxSIPUserAgentLibEx.h"
#import "cVaxSIPUserAgent.h"

@implementation cVaxSIPUserAgentLibEx

- (id) initWithVaxOBJ: (cVaxSIPUserAgent*) pVaxSIPUserAgent;
{
    mpVaxSIPUserAgent = pVaxSIPUserAgent;
    
    self = [super init];
	return self;
}

- (void) dealloc;
{
    [super dealloc];
}

- (Boolean) InitializeEx :(Boolean) bBindToListenIP :(NSString*) pListenIP :(int) nListenPort :(NSString*) pUserName :(NSString*) pLogin :(NSString*) pLoginPwd :(NSString*) pDisplayName :(NSString*) pDomainRealm :(NSString*) pSIPProxy :(NSString*) pSIPOutBoundProxy;
{
    return [super InitializeEx :bBindToListenIP :pListenIP :nListenPort :pUserName :pLogin :pLoginPwd :pDisplayName :pDomainRealm :pSIPProxy :pSIPOutBoundProxy :1];
}

- (void) UnInitialize;
{
    [super UnInitialize];
}

- (Boolean) DialCall :(NSString*) pDialNo;
{
    return [super DialCall :0 :pDialNo :-1 :-1];
}

- (Boolean) Connect :(NSString*) pToURI;
{
    return [super Connect :0 :pToURI :-1 :-1];
}

- (Boolean) Disconnect;
{
    return [super Disconnect :0];
}

- (Boolean) AcceptCall :(NSString*) pCallId;
{
    return [super AcceptCall :0 :pCallId :-1 :-1];
}

- (Boolean) RejectCall :(NSString*) pCallId;
{
    return [super RejectCall :pCallId];
}

- (Boolean) JoinTwoLine :(int) nLineNo;
{
    return [super JoinTwoLine :0 :nLineNo];
}

- (Boolean) TransferCallEx :(NSString*) pToUserName;
{
    return [super TransferCallEx :0 :pToUserName];
}

- (Boolean) TransferCall :(NSString*) pToURI;
{
    return [super TransferCall :0 :pToURI];
}

- (Boolean) HoldLine;
{
    return [super HoldLine :0];
}

- (Boolean) UnHoldLine;
{
    return [super UnHoldLine :0];
}

- (Boolean) IsLineConnected;
{
    return [super IsLineConnected :0];
}

- (Boolean) IsLineBusy;
{
    return [super IsLineBusy :0];
}

- (Boolean) IsLineOpen;
{
    return [super IsLineOpen :0];
}

- (Boolean) IsLineHold;
{
    return [super IsLineHold :0];
}

- (Boolean) OpenLine :(Boolean) bBindToRTPRxIP :(NSString*) pRTPRxIP :(int) nRTPRxPort;
{
    return [super OpenLine :0 :bBindToRTPRxIP :pRTPRxIP :nRTPRxPort];
}

- (Boolean) DigitDTMF :(int) nDigit;
{
    return [super DigitDTMF :0 :nDigit];
}

- (Boolean) MuteLineSPK :(Boolean) bEnable;
{
    return [super MuteLineSPK :0 :bEnable];
}

- (Boolean) MuteLineMIC :(Boolean) bEnable;
{
    return [super MuteLineMIC :0 :bEnable];
}

- (Boolean) ForceInbandDTMF :(Boolean) bEnable;
{
    return [super ForceInbandDTMF :0 :bEnable];
}


////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) OnSuccessToRegister;
{
    [mpVaxSIPUserAgent OnSuccessToRegister];
}

- (void) OnSuccessToReRegister;
{
    [mpVaxSIPUserAgent OnSuccessToReRegister];
}

- (void) OnSuccessToUnRegister;
{
    [mpVaxSIPUserAgent OnSuccessToUnRegister];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) OnTryingToRegister;
{
    [mpVaxSIPUserAgent OnTryingToRegister];
}

- (void) OnTryingToReRegister;
{
    [mpVaxSIPUserAgent OnTryingToReRegister];
}

- (void) OnTryingToUnRegister;
{
    [mpVaxSIPUserAgent OnTryingToUnRegister];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) OnFailToRegister :(int) nStatusCode :(NSString*) pReasonPhrase;
{
    [mpVaxSIPUserAgent OnFailToRegister :nStatusCode :pReasonPhrase];
}

- (void) OnFailToReRegister :(int) nStatusCode :(NSString*) pReasonPhrase;
{
    [mpVaxSIPUserAgent OnFailToReRegister :nStatusCode :pReasonPhrase];
}

- (void) OnFailToUnRegister :(int) nStatusCode :(NSString*) pReasonPhrase;
{
    [mpVaxSIPUserAgent OnFailToUnRegister :nStatusCode :pReasonPhrase];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) OnConnecting :(int) nLineNo;
{
    [mpVaxSIPUserAgent OnConnecting];
}

- (void) OnTryingToHold :(int) nLineNo;
{
    [mpVaxSIPUserAgent OnTryingToHold];
}

- (void) OnTryingToUnHold :(int) nLineNo;
{
    [mpVaxSIPUserAgent OnTryingToUnHold];
}

- (void) OnFailToHold :(int) nLineNo;
{
    [mpVaxSIPUserAgent OnFailToHold];
}

- (void) OnFailToUnHold :(int) nLineNo;
{
    [mpVaxSIPUserAgent OnFailToUnHold];
}

- (void) OnSuccessToHold :(int) nLineNo;
{
    [mpVaxSIPUserAgent OnSuccessToHold];
}

- (void) OnSuccessToUnHold :(int) nLineNo;
{
    [mpVaxSIPUserAgent OnSuccessToUnHold];
}

- (void) OnFailToConnect :(int) nLineNo;
{
    [mpVaxSIPUserAgent OnFailToConnect];
}

- (void) OnConnected :(int) nLineNo :(NSString*) pTxRTPIP :(int) nTxRTPPort :(NSString*) pCallId;
{
    [mpVaxSIPUserAgent OnConnected];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) OnIncomingCall :(NSString*) pCallId :(NSString*) pDisplayName :(NSString*) pUserName :(NSString*) pFromURI :(NSString*) pToURI;
{
    [mpVaxSIPUserAgent OnIncomingCall :pCallId :pDisplayName :pUserName];
}

- (void) OnIncomingCallRingingStart :(NSString*) pCallId;
{
    [mpVaxSIPUserAgent OnIncomingCallRingingStart :pCallId];
}

- (void) OnIncomingCallRingingStop :(NSString*) pCallId;
{
     [mpVaxSIPUserAgent OnIncomingCallRingingStop :pCallId];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) OnProvisionalResponse :(int) nLineNo :(int) nStatusCode :(NSString*) pReasonPharase;
{
    [mpVaxSIPUserAgent OnProvisionalResponse :nStatusCode :pReasonPharase];
}

- (void) OnFailureResponse :(int) nLineNo :(int) nStatusCode :(NSString*) pReasonPharase;
{
    [mpVaxSIPUserAgent OnFailureResponse :nStatusCode :pReasonPharase];
}

- (void) OnRedirectResponse :(int) nLineNo :(int) nStatusCode :(NSString*) pReasonPharase :(NSString*) pContact;
{
    [mpVaxSIPUserAgent OnRedirectResponse :nStatusCode :pReasonPharase :pContact];
}

- (void) OnDisconnectCall :(int) nLineNo;
{
    [mpVaxSIPUserAgent OnDisconnectCall];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) OnCallTransferAccepted :(int) nLineNo;
{
    [mpVaxSIPUserAgent OnCallTransferAccepted];
}

- (void) OnFailToTransfer :(int) nLineNo :(int) nStatusCode :(NSString*) pReasonPharase;
{
    [mpVaxSIPUserAgent OnFailToTransfer :nStatusCode :pReasonPharase];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) OnIncomingDiagnostic :(NSString*) pMsgSIP :(NSString*) pFromIP :(int) nFromPort;
{
    [mpVaxSIPUserAgent OnIncomingDiagnostic :pMsgSIP :pFromIP :nFromPort];
}

- (void) OnOutgoingDiagnostic :(NSString*) pMsgSIP :(NSString*) pToIP :(int) nToPort;
{
    [mpVaxSIPUserAgent OnOutgoingDiagnostic :pMsgSIP :pToIP :nToPort];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) OnVaxCaptureDevice;
{
    [mpVaxSIPUserAgent OnVaxCaptureDevice];
}

- (void) OnVaxReleaseDevice;
{
    [mpVaxSIPUserAgent OnVaxReleaseDevice];
}

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

- (void) OnSendDataSIP :(char*) pData :(int) nDataSize :(char*) pToIP :(int) nToPort;
{
    [mpVaxSIPUserAgent OnSendDataSIP :pData :nDataSize :pToIP :nToPort];
}

- (void) OnSendDataRTP :(int) nLineNo :(char*) pData :(int) nDataSize :(char*) pToIP :(int) nToPort;
{
    [mpVaxSIPUserAgent OnSendDataRTP :nLineNo :pData :nDataSize :pToIP :nToPort];
}

- (void) OnRecvDataSIP :(char*) pData :(int) nDataSize :(char*) pFromIP :(int)nFromPort;
{
    [mpVaxSIPUserAgent OnRecvDataSIP :pData :nDataSize :pFromIP :nFromPort];
}

- (void) OnRecvDataRTP :(int) nLineNo :(char*) pData :(int) nDataSize :(char*) pFromIP :(int)nFromPort;
{
    [mpVaxSIPUserAgent OnRecvDataRTP :nLineNo :pData :nDataSize :pFromIP :nFromPort];
}



@end
