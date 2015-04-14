//
//  cVaxSIPUserAgentPhoneLines.h
//  Softphone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cVaxGeneral.h"

@class cDialpadView;
@class VaxBell;

@interface cVaxSIPUserAgentPhone : NSObject 
{
    NSMutableString* m_pIncomingCallId;
    
    NSMutableString* m_pIncomingCallerName;
    NSMutableString* m_pIncomingCallerPhoneNo;
    NSMutableString* m_pIncomingCallerId;
    
    int m_nPhoneStatus;

    cDialpadView* mDialpadView;
    VaxBell* mBell;
}

- (id) init;
- (void) dealloc;

- (void) InitOBJ;
- (void) UnInitOBJ;

- (void) SetDialpadView :(UIViewController*) pView;
- (Boolean) OpenLine :(Boolean) bNetworkPortRandom;

- (Boolean) DialCall:(NSString*) DialNo;
- (Boolean) AcceptCall;
- (Boolean) RejectCall;
- (void) DisconnectCall;

- (Boolean) HoldCall;
- (Boolean) UnHoldCall;

- (int) GetPhoneStatus;
- (void) MuteIncomingCall;

- (void) OnConnecting;

- (void) OnTryingToHold;
- (void) OnTryingToUnHold;

- (void) OnFailToHold;
- (void) OnFailToUnHold;

- (void) OnSuccessToHold;
- (void) OnSuccessToUnHold;

- (void) OnFailToConnect;
- (void) OnConnected;

- (void) OnProvisionalResponse :(int) nStatusCode :(NSString*) pReasonPharase;
- (void) OnFailureResponse :(int) nStatusCode :(NSString*) pReasonPharase;
- (void) OnRedirectResponse :(int) nStatusCode :(NSString*) pReasonPharase :(NSString*) pContact;

- (void) OnDisconnectCall;

- (void) OnCallTransferAccepted;
- (void) OnFailToTransfer :(int) nStatusCode :(NSString*) pReasonPharase;

- (void) OnIncomingCall :(NSString*) pCallId :(NSString*) pDisplayName :(NSString*) pUserName;

- (void) OnIncomingCallRingingStart :(NSString*) pCallId;
- (void) OnIncomingCallRingingStop :(NSString*) pCallId;

- (void) SetRingTone :(int) nRingToneId;
- (int) GetRingTone;


@end
