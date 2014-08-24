//
//  BaseService.m
//  Roming
//
//  Created by Karen Ghandilyan on 8/23/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import "BaseService.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "ResponseObject.h"

@implementation BaseService

- (void)requestPOSTAPIWithCommand:(NSString *)command
                       parameters:(NSDictionary *)parameters
                  completionBlock:(void(^)(ResponseObject *responseObject))success
                     failureBlock:(void(^)(NSError *error))failure
{
    NSURL *url= [NSURL URLWithString:BASE_URL];;

    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    NSLog(@"url = %@%@",url,command );
    NSLog(@"postParams = %@",postParams);
    [manager POST:command parameters:postParams success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        NSDictionary *responseJSON = (NSDictionary *)responseObject;
        ResponseObject *responseObj = [[ResponseObject alloc] initWithDictionary:responseJSON];
        if (success) {
            success(responseObj);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)requestGETAPIWithCommand:(NSString *)command
                      parameters:(NSDictionary *)parameters
                 completionBlock:(void(^)(NSDictionary *responseDictionary))success
                    failureBlock:(void(^)(NSDictionary *error))failure
{
    NSURL *url = [NSURL URLWithString:BASE_URL];;

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithDictionary:parameters];

    NSLog(@"url = %@%@",url,command );
    NSLog(@"postParams = %@",postParams);
    [manager GET:command parameters:postParams success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        NSDictionary *responseJSON = (NSDictionary *)responseObject;
        if ([[responseJSON objectForKey:@"status"] isEqualToString:@"ok"]) {
            if (success) {
                success(responseJSON);
            }
        } else {
            NSDictionary *errorObj = @{
                                       @"error":[NSNull null],
                                       @"errorJSON":responseJSON
                                       };
            if (failure) {
                failure(errorObj);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSDictionary *errorObj = @{
                                   @"error":error,
                                   @"errorJSON":[NSNull null]
                                   };
        if (failure) {
            failure(errorObj);
        }
    }];
}

@end
