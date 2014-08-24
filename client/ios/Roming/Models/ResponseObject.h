//
//  ResponseObject.h
//  Roming
//
//  Created by Karen Ghandilyan on 8/23/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
@interface ResponseObject : NSObject

@property (nonatomic, assign) ResponseStatus responseStatus;
@property (nonatomic, strong) NSDictionary *responseData;
@property (nonatomic, strong) NSDictionary *responseError;

-(id)initWithDictionary:(NSDictionary *)dictionary;
@end
