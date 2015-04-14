//
//  cVaxSIPUserAgentPhoneLines.m
//  Softphone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import "cVaxSIPUserAgentEx.h"
#import "cVaxGeneral.h"
#import "VaxBell.h"
#import "cVaxSIPUserAgentPhone.h"
//#import "cDialpadView.h"
#import "cAddressBook.h"
#import "cAudioMedia.h"

@implementation cVaxSIPUserAgentPhone

- (id) init;
{		
	self = [super init];
	
    mDialpadView = nil;
    m_nPhoneStatus = VAX_LINE_STATUS_FREE;
    
    m_pIncomingCallId = [[NSMutableString alloc] init];
    m_pIncomingCallerId = [[NSMutableString alloc] init];
    m_pIncomingCallerName = [[NSMutableString alloc] init];
    m_pIncomingCallerPhoneNo = [[NSMutableString alloc] init]; 
    
    mBell = [VaxBell new];
	return self;
}

- (void) dealloc;
{	
	[super dealloc];
    
    [m_pIncomingCallId release];
    [m_pIncomingCallerId release];
    [m_pIncomingCallerName release];
    [m_pIncomingCallerPhoneNo release];
        
    [mBell release];
}

- (void) InitOBJ;
{
    [mBell InitOBJ];
}

- (void) UnInitOBJ;
{
    [mBell UnInitOBJ];
}

- (void) SetDialpadView :(UIViewController*) pView;
{
    mDialpadView = (cDialpadView*) pView;
}

///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

- (void) SetPhoneStatus :(int) nStatus;
{
    m_nPhoneStatus = nStatus;
}

- (int) GetPhoneStatus;
{
	return m_nPhoneStatus;
}

///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

- (Boolean) DialCall:(NSString*) DialNo;
{
    DialNo = [cAddressBook FilterPhoneNo: DialNo];
    
    Boolean bResult = [[cVaxSIPUserAgentEx GetOBJ] DialCall: DialNo];
	
	if(bResult)
    {
        [self SetPhoneStatus :VAX_LINE_STATUS_CONNECTING];
    }
	
	return bResult;
}

- (Boolean) AcceptCall;
{
    [mBell StopRingTone];
    
    Boolean bResult = [[cVaxSIPUserAgentEx GetOBJ] AcceptCall: m_pIncomingCallId];
	
	if(bResult)
    {
        [self SetPhoneStatus :VAX_LINE_STATUS_CONNECTING];
    }
	
	return bResult;
}

- (Boolean) RejectCall;
{
    [mBell StopRingTone];
    
    Boolean bResult = [[cVaxSIPUserAgentEx GetOBJ] RejectCall: m_pIncomingCallId];
	
	if(bResult)
        [self SetPhoneStatus :VAX_LINE_STATUS_FREE];
    
	return bResult;
}

- (void) DisconnectCall;
{
    [self SetPhoneStatus :VAX_LINE_STATUS_FREE];
    
    [mBell StopDialTone];
    [mBell StopBusyTone];

	[[cVaxSIPUserAgentEx GetOBJ] Disconnect];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) HoldCall;
{
    [self SetPhoneStatus :VAX_LINE_STATUS_HOLD];
    return [[cVaxSIPUserAgentEx GetOBJ] HoldLine];
}

- (Boolean) UnHoldCall;
{
    [self SetPhoneStatus :VAX_LINE_STATUS_CONNECTED];
    return [[cVaxSIPUserAgentEx GetOBJ] UnHoldLine];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) OnTryingToHold;
{
    [mDialpadView OnTryingToHold];
}

- (void) OnTryingToUnHold;
{
    [mDialpadView OnTryingToUnHold];
}

- (void) OnFailToHold;
{
    [mDialpadView OnFailToHold];
}

- (void) OnFailToUnHold;
{
    [mDialpadView OnFailToUnHold];
}

- (void) OnSuccessToHold;
{
    [self SetPhoneStatus :VAX_LINE_STATUS_HOLD];
    [mDialpadView OnSuccessToHold];
}

- (void) OnSuccessToUnHold;
{
    [self SetPhoneStatus :VAX_LINE_STATUS_CONNECTED];
    [mDialpadView OnSuccessToUnHold];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) OnConnecting;
{
    [self SetPhoneStatus :VAX_LINE_STATUS_CONNECTING];
    [mDialpadView OnConnecting];
}

- (void) OnFailToConnect;
{
    [self SetPhoneStatus :VAX_LINE_STATUS_FREE];
    
    [mBell StopDialTone];
    [mDialpadView OnFailToConnect];
}

- (void) OnConnected;
{
    [self SetPhoneStatus :VAX_LINE_STATUS_CONNECTED];
    
    [mBell StopDialTone];
    [mDialpadView OnConnected];
}

- (void) OnDisconnectCall;
{
    [self SetPhoneStatus :VAX_LINE_STATUS_FREE];
    [mDialpadView OnDisconnectCall];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) OnProvisionalResponse :(int) nStatusCode :(NSString*) pReasonPharase;
{
	if(nStatusCode == 180)       // Ringing response from SIP SERVER.
        [mBell StartDialTone];
    
    else if(nStatusCode == 183)  // Session Progress response from SIP SERVER.
        [mBell StopDialTone];
    
    [mDialpadView OnProvisionalResponse: nStatusCode: pReasonPharase];
}

- (void) OnFailureResponse :(int) nStatusCode :(NSString*) pReasonPharase;
{
	[mBell StopDialTone];
    
    int nPhoneStatus = [self GetPhoneStatus];
    
    if(nPhoneStatus == VAX_LINE_STATUS_CONNECTING)
        [mBell StartBusyTone];
    
    [mDialpadView OnFailureResponse: nStatusCode: pReasonPharase];
}

- (void) OnRedirectResponse :(int) nStatusCode :(NSString*) pReasonPharase :(NSString*) pContact;
{
    [mBell StopDialTone];
    
    int nPhoneStatus = [self GetPhoneStatus];
    
    if(nPhoneStatus == VAX_LINE_STATUS_CONNECTING)
        [mBell StartBusyTone];

    [mDialpadView OnRedirectResponse: nStatusCode: pReasonPharase: pContact];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) OnCallTransferAccepted;
{
	[mDialpadView OnCallTransferAccepted];
}

- (void) OnFailToTransfer :(int) nStatusCode :(NSString*) pReasonPharase;
{
	[mDialpadView OnFailToTransfer: nStatusCode: pReasonPharase];
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) OnIncomingCall :(NSString*) pCallId :(NSString*) pDisplayName :(NSString*) pUserName;
{
	int nPhoneStatus = [self GetPhoneStatus];
	
	if(nPhoneStatus != VAX_LINE_STATUS_FREE)
	{
		[[cVaxSIPUserAgentEx GetOBJ] RejectCall: pCallId];
		return;
	}
    
	[m_pIncomingCallId setString: pCallId];
    [self SetPhoneStatus: VAX_LINE_STATUS_INCOMING];
	    
    NSMutableString* pCallerName = [[NSMutableString new] autorelease];
    NSMutableString* pCallerPhoneNo = [[NSMutableString new] autorelease];
    NSMutableString* pCallerId = [[NSMutableString new] autorelease];
    
    [self PrepareCallerInfo: pDisplayName: pUserName: pCallerName: pCallerPhoneNo: pCallerId];
    
    [m_pIncomingCallerName setString: pCallerName];
    [m_pIncomingCallerPhoneNo setString: pCallerPhoneNo];
    [m_pIncomingCallerId setString: pCallerId];
    
    [self NotifyIncomingCall: pCallerName: pCallerPhoneNo: pCallerId];
}

- (void) OnIncomingCallRingingStart :(NSString*) pCallId;
{
    [self SetPhoneStatus :VAX_LINE_STATUS_INCOMING];
	[mBell StartRingTone];
    [mDialpadView OnIncomingCallRingStart: m_pIncomingCallerId];
}

- (void) OnIncomingCallRingingStop :(NSString*) pCallId;
{
    [self SetPhoneStatus :VAX_LINE_STATUS_FREE];
	[mBell StopRingTone];
    [mDialpadView OnIncomingCallRingEnd];
}

- (void) NotifyIncomingCall :(NSString*) pCallerName :(NSString*) pCallerPhoneNo :(NSString*) pCallerId;
{
    UILocalNotification* Notify = [[[UILocalNotification alloc] init] autorelease];
    
    Notify.alertBody = [NSString stringWithFormat: @"Incoming Call: %@", pCallerId];
	
    Notify.alertAction = @"Answer";
    Notify.soundName   = @"oldphone-mono-30s.caf";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow: Notify];
}

- (void) PrepareCallerInfo :(NSString*) pDisplayName :(NSString*) pUserName :(NSMutableString*) pCallerName :(NSMutableString*) pCallerPhoneNo :(NSMutableString*) pCallerId;
{
    if([pDisplayName length] != 0 && [pUserName length] != 0)
    {
		if([pDisplayName caseInsensitiveCompare: pUserName] == NSOrderedSame)
        {
            [pCallerName setString: @""];
            [pCallerPhoneNo setString: pUserName];
        }
        else
        {
            [pCallerName setString: pDisplayName];
            [pCallerPhoneNo setString: pUserName];
        }
    }
	
	else if([pDisplayName length] != 0 && [pUserName length] == 0)
    {
		[pCallerPhoneNo setString: pDisplayName];
        [pCallerName setString: @""];
    }
    
    else if([pDisplayName length] == 0 && [pUserName length] != 0)
    {
		[pCallerPhoneNo setString: pUserName];
        [pCallerName setString: @""];
    }
    
	else
    {
		[pCallerPhoneNo setString: @"Unknown"];
        [pCallerName setString: @""];
    }
    
    cAddressBook* AddressBook = [cAddressBook new];
    NSString* pNameAB = [AddressBook FindContactNameWithPhoneNo: pCallerPhoneNo];
    
    if(pNameAB == NULL)
        [pCallerId setString: pCallerPhoneNo];
    else
        [pCallerId setString: pNameAB];
    
    [AddressBook release];
}


////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (Boolean) OpenLine :(Boolean) bNetworkPortRandom;
{
    Boolean bResult = false;
    
    int nListenPort = DEFAULT_LISTEN_PORT_RTP;
    NSString* pMyIP = [[cVaxSIPUserAgentEx GetOBJ] GetMyIP];
	
    for (int nCount = 0; nCount < 500; nCount++)
    {
        if(bNetworkPortRandom)
            nListenPort = [cVaxGeneral CalcListenPort];
        
        if (![[cVaxSIPUserAgentEx GetOBJ] OpenLine :false :pMyIP :nListenPort])
        {
            if ([[cVaxSIPUserAgentEx GetOBJ] GetVaxObjectError] != VAX_ERROR_COMMUNICATION_PORT_PROBLEM)
            {
                [[cVaxSIPUserAgentEx GetOBJ] ErrorMessage];
                return false;
            }
            
            bResult = false;
        }
        else
        {
            //[[cVaxSIPUserAgentEx GetOBJ] ForceInbandDTMF :true];
            bResult = true;
            break;
        }
		
        nListenPort += 2; //It is importent to increament RTP Listen port by 2
    }
    
    if (bResult == false)
    {
        [cVaxSIPUserAgentEx MessageBox: @"Local RTP communication port is currently busy, please re-try!"];
    }

    [self SetPhoneStatus :VAX_LINE_STATUS_FREE];
    return bResult;
}

- (void) MuteIncomingCall;
{
    [mBell StopRingTone]; 
}

- (void) SetRingTone :(int) nRingToneId;
{
    [mBell SetRingTone: nRingToneId];
}
     
- (int) GetRingTone;
{
    return [mBell GetRingTone];
}

@end
