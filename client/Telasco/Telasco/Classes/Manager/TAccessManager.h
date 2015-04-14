//
//  TAccessManager.h
//  Telasco
//
//  Created by Janna Hakobyan on 3/9/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TBaseViewController.h"

@interface TAccessManager : TBaseViewController

- (void)enabledMicrophoneAccess;
- (void)enabledContactsAccess;

+ (TAccessManager *)sharedInstance;
//- (BOOL)isMicrophoneAccessEnabled;
//- (BOOL)isContactsAccessEnabled;

@end
