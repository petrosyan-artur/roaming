//
//  cVaxSIPUserAgentAccountEvents.h
//  Softphone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class cAccountTableView;
@class cDialpadView;

@interface cVaxSIPUserAgentAccount : NSObject
{
    cDialpadView* mDialpadView;
    cAccountTableView* mAccountTableView;
}

- (id) init;
- (void) dealloc;

- (void) SetPhoneDetailTableView :(UIViewController*) pView;
- (void) SetAccountTableView :(UITableViewController*) pView;

- (void) OnStartToRegister;

- (void) OnInitialize;
- (void) OnUnInitialize;

- (void) OnSuccessToRegister;
- (void) OnSuccessToReRegister;
- (void) OnSuccessToUnRegister;

- (void) OnTryingToRegister;
- (void) OnTryingToReRegister;
- (void) OnTryingToUnRegister;

- (void) OnFailToRegister :(int) nStatusCode :(NSString*) pReasonPhrase;
- (void) OnFailToReRegister :(int) nStatusCode :(NSString*) pReasonPhrase;
- (void) OnFailToUnRegister :(int) nStatusCode :(NSString*) pReasonPhrase;

- (void) OnNetworkReachability :(Boolean) bAvailable;

@end
