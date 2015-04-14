//
//  AppDelegate.h
//  Telasco
//
//  Created by Janna Hakobyan on 3/2/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "TTelasco.h"

@class cVaxSIPUserAgentEx;
@class cDialpadView;
@class cContactsView;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    cVaxSIPUserAgentEx *mVaxVoIP;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;
@property (nonatomic) BOOL isNetworkReachable;
@property (nonatomic, strong) TTelasco *telasco;
+ (instancetype) sharedInstance;

@end

