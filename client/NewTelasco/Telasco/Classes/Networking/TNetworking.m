
//
//  TNetworking.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/2/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TNetworking.h"
#import "AFHTTPRequestOperationManager+timeout.h"
#import "Utils.h"

#define PNTimeout 6.0

@implementation TNetworking

+ (TNetworking *)sharedInstance
{
    static TNetworking *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TNetworking alloc] init];
    });
    return sharedInstance;
}

- (void)sendPhoneNumber:(NSString *)phoneNumber completion:(void (^)(NSDictionary *data, NSString *errorStr, NSError *error))completion
{
    NSString *baseURL = [NSString stringWithFormat:@"%@/user/request-pin", BASE_URL];
    NSDictionary *params = @{@"phone" : phoneNumber};
    
    NSLog(@"sendPhoneNumber param: %@", params);
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    [operationManager POST:baseURL parameters:params timeoutInterval:PNTimeout success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *data = responseObject;
         NSLog(@"sendPhoneNumber %@", data);
         if ([data valueForKey:@"errors"] != (id)[NSNull null]) {
             completion(nil, [data valueForKey:@"errors"], nil);
             return;
         }
         
         if(completion) {
             completion(data, nil, nil);
         }
     }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"err resp %@",operation.responseString);
         if(completion)
             completion(nil, nil, error);
     }];
}

- (void)veridicationCode:(NSString *)phoneNumber code:(NSString *)code completion:(void (^)(NSDictionary *data, NSString *errorStr, NSError *error))completion
{
    
    NSString *baseURL = [NSString stringWithFormat:@"%@/auth/authenticate", BASE_URL];
    NSDictionary *params = @{@"phone" : phoneNumber,
                             @"pin"   : code,
                             @"app_version" : @"0.01",
                             @"device_token" : [Utils readFromUserDefaults:kPrefDeviceToken]
                             };
    
    NSLog(@"veridicationCode param: %@", params);
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    [operationManager POST:baseURL parameters:params timeoutInterval:PNTimeout success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *data = responseObject;
         NSLog(@"veridicationCode %@", data);
         if ([data valueForKey:@"errors"] != (id)[NSNull null]) {
             completion(nil, [data valueForKey:@"errors"], nil);
             return;
         }
         [Utils saveCookies];
         if(completion) {
             completion(data, nil, nil);
         }
     }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"err resp %@",operation.responseString);
         if(completion)
             completion(nil, nil, error);
     }];
}

- (void)getRate:(NSArray *)phoneNumbers completion:(void (^)(NSDictionary *data, NSString *errorStr, NSError *error))completion
{
    NSString *baseURL = [NSString stringWithFormat:@"%@/rate/get", BASE_URL];
    NSDictionary *params = @{@"phones" : phoneNumbers};
    NSLog(@"getRate %@", params);
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];

    [operationManager POST:baseURL parameters:params timeoutInterval:PNTimeout success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *data = responseObject;
         NSLog(@"getRate %@", data);
         if (![[data valueForKey:@"status"] isEqual: @(1)]) {
             completion(nil, [data valueForKey:@"status"], nil);
             return;
         }
         
         if ([data valueForKey:@"errors"] != (id)[NSNull null]) {
             completion(nil, [data valueForKey:@"errors"], nil);
             return;
         }
         
         if(completion) {
             completion([data valueForKey:@"data"], nil, nil);
         }
     }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"err resp %@",operation.responseString);
         if(completion)
             completion(nil, nil, error);
     }];
}

- (void)logout:(void (^)(NSDictionary *data, NSString *errorStr, NSError *error))completion
{
    NSString *baseURL = [NSString stringWithFormat:@"%@/auth/logout", BASE_URL];

    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    [operationManager GET:baseURL parameters:nil timeoutInterval:PNTimeout success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *data = responseObject;
         NSLog(@"logout %@", data);
         if (![[data valueForKey:@"status"] isEqual: @(1)]) {
             completion(nil, [data valueForKey:@"status"], nil);
             return;
         }
         
         if ([data valueForKey:@"errors"] != (id)[NSNull null]) {
             completion(nil, [data valueForKey:@"errors"], nil);
             return;
         }
         
         if(completion) {
             completion([data valueForKey:@"data"], nil, nil);
         }
     }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"err resp %@",operation.responseString);
         if(completion)
             completion(nil, nil, error);
     }];
}


- (void)getAccountInfo:(void (^)(NSDictionary *data, NSString *errorStr, NSError *error))completion
{
    NSString *baseURL = [NSString stringWithFormat:@"%@/user/account-info", BASE_URL];
    
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    [operationManager GET:baseURL parameters:nil timeoutInterval:PNTimeout success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *data = responseObject;
         NSLog(@"getAccountInfo %@", data);
         if (![[data valueForKey:@"status"] isEqual: @(1)]) {
             completion(nil, [data valueForKey:@"status"], nil);
             return;
         }
         
         if ([data valueForKey:@"errors"] != (id)[NSNull null]) {
             completion(nil, [data valueForKey:@"errors"], nil);
             return;
         }
         
         if(completion) {
             completion([data valueForKey:@"data"], nil, nil);
         }
     }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"err resp %@",operation.responseString);
         if(completion)
             completion(nil, nil, error);
     }];
}

- (NSString *)checkError:(id)responseObject
{
    return [responseObject valueForKey:@"error"];
}


@end
