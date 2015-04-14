//
//  NetWorkReach.h
//  Softphone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	NotReachable = 0,
	ReachableViaWiFi,
	ReachableViaWWAN
} NetworkStatus;

@interface NetWorkReach : NSObject
{
    
}

+ (Boolean) IsNetworkAvailable;
+ (Boolean) SetNetworkReachability :(Boolean) bEnable;

@end
