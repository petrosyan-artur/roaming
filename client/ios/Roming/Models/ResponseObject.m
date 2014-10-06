//
//  ResponseObject.m
//  Roming
//
//  Created by Karen Ghandilyan on 8/23/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import "ResponseObject.h"

@implementation ResponseObject
@synthesize responseData, responseError, responseStatus;

-(id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        // Main init process
        [self parseAndFillDataForDictionary:dictionary];
    }
    return self;
}

-(void)parseAndFillDataForDictionary:(NSDictionary *)dict {
    self.responseData = dict[@"data"];
    self.responseError = dict[@"errors"];
    self.responseStatus = [dict[@"status"] intValue];
}

@end
