//
//  TNetworking.h
//  Telasco
//
//  Created by Janna Hakobyan on 3/2/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface TNetworking : NSObject

+ (TNetworking *)sharedInstance;

- (void)sendPhoneNumber:(NSString *)phoneNumber completion:(void (^)(NSDictionary *data, NSString *errorStr, NSError *error))completion;
- (void)getCountryList:(void (^)(NSDictionary *data, NSString *errorStr, NSError *error))completion;
- (void)veridicationCode:(NSString *)phoneNumber code:(NSString *)code completion:(void (^)(NSDictionary *data, NSString *errorStr, NSError *error))completion;
- (void)getRate:(NSArray *)phoneNumbers completion:(void (^)(NSDictionary *data, NSString *errorStr, NSError *error))completion;

@end
