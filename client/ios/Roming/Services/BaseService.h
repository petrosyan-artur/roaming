//
//  BaseService.h
//  Roming
//
//  Created by Karen Ghandilyan on 8/23/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ResponseObject;

@interface BaseService : NSObject
- (void)requestPOSTAPIWithCommand:(NSString *)command
                       parameters:(NSDictionary *)parameters
                  completionBlock:(void(^)(ResponseObject *responseObject))success
                     failureBlock:(void(^)(NSError *error))failure;

- (void)requestGETAPIWithCommand:(NSString *)command
                      parameters:(NSDictionary *)parameters
                 completionBlock:(void(^)(NSDictionary *responseDictionary))success
                    failureBlock:(void(^)(NSDictionary *error))failure;
@end
