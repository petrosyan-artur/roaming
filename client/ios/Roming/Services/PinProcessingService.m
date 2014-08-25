//
//  PinProcessingService.m
//  Roming
//
//  Created by Karen Ghandilyan on 8/23/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import "PinProcessingService.h"
#import "ResponseObject.h"

NSString *const PIN_CODE_PROCESSING_COMMAND = @"/api/user/request-pin";
@implementation PinProcessingService

-(void)requestPinCodeForPhoneNumber:(NSString *)phoneNumber
                         completion:(void(^)(ResponseObject *responseObj, BOOL success, NSString *errorMessage))success {
    NSDictionary *parameters = @{
                                 @"phone":phoneNumber
                                 };
    [self requestPOSTAPIWithCommand:PIN_CODE_PROCESSING_COMMAND
                         parameters:parameters
                    completionBlock:^(ResponseObject *responseObject) {
                        if (success) {
                            success(responseObject, YES, @"");
                        }
                         } failureBlock:^(NSError *error) {
                             if (success) {
                                 success(nil, NO, error.localizedDescription);
                             }
                         }];
    
}

@end
