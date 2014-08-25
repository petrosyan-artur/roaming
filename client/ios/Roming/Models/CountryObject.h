//
//  CountryObject.h
//  Roming
//
//  Created by Karen Ghandilyan on 8/23/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountryObject : NSObject

@property (nonatomic, strong) NSString *countryName;
@property (nonatomic, strong) NSString *dialCode;
@property (nonatomic, strong) NSString *countryCode;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
