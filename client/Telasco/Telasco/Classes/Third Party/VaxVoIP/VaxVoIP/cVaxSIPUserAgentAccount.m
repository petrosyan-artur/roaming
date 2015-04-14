//
//  cVaxSIPUserAgentAccountEvents.m
//  Softphone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import "cVaxSIPUserAgentAccount.h"
//#import "cAccountTableView.h"
//#import "cDialpadView.h"
#import "cVaxGeneral.h"
#import "NetWorkReach.h"

@implementation cVaxSIPUserAgentAccount

- (id) init;
{
	self = [super init];
	
    mDialpadView = NULL;
    mAccountTableView = NULL;
    
    return self;
}

- (void) dealloc;
{
	[super dealloc];
}

- (void) SetAccountTableView :(UITableViewController*) pView;
{
	mAccountTableView = (cAccountTableView*) pView;
}

- (void) SetPhoneDetailTableView :(UIViewController*) pView;
{
    mDialpadView = (cDialpadView*) pView;
}

- (void) OnStartToRegister;
{
    [self UpdateStatusInView :VAX_REG_STATUS_TRYING :NULL];
}

- (void) OnInitialize;
{
    if(![NetWorkReach IsNetworkAvailable])
	{
        [self UpdateStatusInView :VAX_REG_STATUS_NETWORK_NOT_FOUND :NULL];
	}
    else
    {
        [self UpdateStatusInView :VAX_REG_STATUS_ONLINE :NULL];
    }
}

- (void) OnUnInitialize;
{
    [self UpdateStatusInView :VAX_REG_STATUS_OFFLINE :NULL];
}

- (void) OnSuccessToRegister;
{
    [self UpdateStatusInView :VAX_REG_STATUS_SUCCESS :NULL];
}

- (void) OnSuccessToReRegister;
{
    [self UpdateStatusInView :VAX_REREG_STATUS_SUCCESS :NULL];
}

- (void) OnSuccessToUnRegister;
{
    [self UpdateStatusInView :VAX_UNREG_STATUS_SUCCESS :NULL];
}

- (void) OnTryingToRegister;
{
    [self UpdateStatusInView :VAX_REG_STATUS_TRYING :NULL];
}

- (void) OnTryingToReRegister;
{
    [self UpdateStatusInView :VAX_REREG_STATUS_TRYING :NULL];
}

- (void) OnTryingToUnRegister;
{
    [self UpdateStatusInView :VAX_UNREG_STATUS_TRYING :NULL];
}

- (void) OnFailToRegister :(int) nStatusCode :(NSString*) pReasonPhrase;
{
    [self UpdateStatusInView :VAX_UNREG_STATUS_FAILED :pReasonPhrase];
}

- (void) OnFailToReRegister :(int) nStatusCode :(NSString*) pReasonPhrase;
{
    [self UpdateStatusInView :VAX_UNREG_STATUS_FAILED :pReasonPhrase];
}

- (void) OnFailToUnRegister :(int) nStatusCode :(NSString*) pReasonPhrase;
{
    [self UpdateStatusInView :VAX_UNREG_STATUS_FAILED :pReasonPhrase];
}

- (void) OnNetworkReachability :(Boolean) bAvailable;
{
    if(mAccountTableView != NULL)
        [mAccountTableView OnNetworkReachability: bAvailable];
}

- (void) UpdateStatusInView :(int) nStatusId :(NSString*) pStatusPhrase;
{
//    if(mAccountTableView != NULL)
//        [mAccountTableView UpdateStatusInView :nStatusId :pStatusPhrase];
//    
    if(mDialpadView != NULL)
        [mDialpadView UpdateAccountStatusInView :nStatusId :pStatusPhrase];
}


@end
