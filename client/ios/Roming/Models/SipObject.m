//
//  SipObject.m
//  Rouming
//
//  Created by Karen Ghandilyan on 9/11/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import "SipObject.h"

@implementation SipObject
-(id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.hostName = dictionary[@"host"];
        self.password = dictionary[@"password"];
        self.port = dictionary[@"port"];
        self.username = dictionary[@"username"];
    }
    return self;
}
@end
