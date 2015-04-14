//
//  NetWorkReach.m
//  Softphone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import "NetWorkReach.h"
#import "cVaxSIPUserAgentEx.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <SystemConfiguration/SystemConfiguration.h>

static SCNetworkReachabilityRef m_NetworkReachability = NULL;

@implementation NetWorkReach

+ (NetworkStatus) networkStatusForFlags :(SCNetworkReachabilityFlags) flags
{
	if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
	{
		// if target host is not reachable
		return NotReachable;
	}
	
	BOOL retVal = NotReachable;
	
	if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
	{
		// if target host is reachable and no connection is required
		//  then we'll assume (for now) that your on Wi-Fi
		retVal = ReachableViaWiFi;
	}
	
	
	if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
		 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
	{
		// ... and the connection is on-demand (or on-traffic) if the
		//     calling application is using the CFSocketStream or higher APIs
		
		if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
		{
			// ... and no [user] intervention is needed
			retVal = ReachableViaWiFi;
		}
	}
	
	if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
	{
		// ... but WWAN connections are OK if the calling application
		//     is using the CFNetwork (CFSocketStream?) APIs.
		retVal = ReachableViaWWAN;
	}
	return retVal;
}

static void NetworkReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkConnectionFlags flags, void *object)
{
    //Boolean bAvailable = [NetWorkReach IsNetworkAvailable];
    
    Boolean bAvailable = false;
    
    NetworkStatus NetStatus = [NetWorkReach networkStatusForFlags: flags];
	
	if(NetStatus == NotReachable)
		bAvailable = false;
    else
        bAvailable = true;
	
    [[cVaxSIPUserAgentEx GetOBJ] OnVaxNetworkReachability: bAvailable];
}

+ (Boolean) SetNetworkReachability :(Boolean) bEnable;
{
    if(m_NetworkReachability)
    {
        SCNetworkReachabilityUnscheduleFromRunLoop(m_NetworkReachability, [[NSRunLoop currentRunLoop] getCFRunLoop], kCFRunLoopCommonModes);
        
        CFRelease(m_NetworkReachability);
        m_NetworkReachability = NULL;
        
        return true;
    }
    
    if(bEnable)
    {
        SCNetworkReachabilityContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
        
        struct sockaddr_in zeroAddress;
        bzero(&zeroAddress, sizeof(zeroAddress));
        zeroAddress.sin_len = sizeof(zeroAddress);
        zeroAddress.sin_family = AF_INET;
        
        m_NetworkReachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*) &zeroAddress);
        
        if (!SCNetworkReachabilitySetCallback(m_NetworkReachability, NetworkReachabilityCallback, &context))
            return false;
        
        if (!SCNetworkReachabilityScheduleWithRunLoop(m_NetworkReachability, CFRunLoopGetCurrent(), kCFRunLoopCommonModes))
            return false;
        
        return true;
    }
    
    return true;
}

+ (Boolean) IsNetworkAvailable;
{
    struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	SCNetworkReachabilityRef Reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*) &zeroAddress);
	if(Reachability == NULL) return NO;
	
	SCNetworkReachabilityFlags flags;
	
	if (SCNetworkReachabilityGetFlags(Reachability, &flags) == FALSE)
		return NO;
	
	CFRelease(Reachability);
	
	NetworkStatus NetStatus = [NetWorkReach networkStatusForFlags: flags];
	
	if(NetStatus == NotReachable)
		return NO;
	
	return YES;
}

@end
