//
//  TAvailableSubscribtion.m
//  Telasco
//
//  Created by Janna Hakobyan on 4/13/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TAvailableSubscribtion.h"

@implementation TAvailableSubscribtion

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (!self)
        return nil;
    
    if (dict[@"duration"] != [NSNull null])
    {
        self.duration = dict[@"duration"];
    }
  
    if (dict[@"price"] != [NSNull null])
    {
        self.price = dict[@"price"];
    }
    
    if (dict[@"url"] != [NSNull null])
    {
        self.url = dict[@"url"];
    }
    
    return self;
}

@end


