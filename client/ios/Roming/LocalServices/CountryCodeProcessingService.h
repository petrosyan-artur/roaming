//
//  CountryCodeProcessingService.h
//  Roming
//
//  Created by Karen Ghandilyan on 8/23/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CountryObject;

@interface CountryCodeProcessingService : NSObject
+(instancetype)sharedInstance;
-(NSArray *)getCountryCodes;
-(CountryObject *)getFirstCountry;
@end
