//
//  cVaxSIPUserAgentLibEx.h
//  VaxPhone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import "cVaxSIPUserAgentLib.h"

@class cVaxSIPUserAgent;

@interface cVaxSIPUserAgentLibEx : cVaxSIPUserAgentLib
{
    cVaxSIPUserAgent* mpVaxSIPUserAgent;
}

- (id) initWithVaxOBJ: (cVaxSIPUserAgent*) pVaxSIPUserAgent;
- (void) dealloc;

- (Boolean) InitializeEx :(Boolean) bBindToListenIP :(NSString*) pListenIP :(int) nListenPort :(NSString*) pUserName :(NSString*) pLogin :(NSString*) pLoginPwd :(NSString*) pDisplayName :(NSString*) pDomainRealm :(NSString*) pSIPProxy :(NSString*) pSIPOutBoundProxy;

- (void) UnInitialize;

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

- (Boolean) MuteLineSPK :(Boolean) bEnable;
- (Boolean) MuteLineMIC :(Boolean) bEnable;

- (Boolean) ForceInbandDTMF :(Boolean) bEnable;


@end
