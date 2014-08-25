//
//  PinProcessingService.h
//  Roming
//
//  Created by Karen Ghandilyan on 8/23/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import "BaseService.h"

@interface PinProcessingService : BaseService
-(void)requestPinCodeForPhoneNumber:(NSString *)phoneNumber
                         completion:(void(^)(ResponseObject *responseObj, BOOL success, NSString *errorMessage))success ;

@end
