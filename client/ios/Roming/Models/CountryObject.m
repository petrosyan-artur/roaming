//
//  CountryObject.m
//  Roming
//
//  Created by Karen Ghandilyan on 8/23/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import "CountryObject.h"

@implementation CountryObject
@synthesize countryCode, countryName, dialCode;

-(id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.countryName = dictionary[@"name"];
        self.dialCode = dictionary[@"dial_code"];
        self.countryCode = dictionary[@"code"];
    }
    return self;
}
@end
