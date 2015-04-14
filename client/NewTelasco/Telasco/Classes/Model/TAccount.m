//
//  TAccount.m
//  Telasco
//
//  Created by Janna Hakobyan on 4/13/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TAccount.h"
#import "TAvailableSubscribtion.h"

@implementation TAccount

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (!self)
        return nil;
    
    if ([dict[@"balance"] valueForKey:@"active_days"] != [NSNull null])
    {
        self.activeDays = [dict[@"balance"] valueForKey:@"active_days"];
    }
    
    if ([dict[@"balance"] valueForKey:@"bonus_days"] != [NSNull null])
    {
        self.bonusDays = [dict[@"balance"] valueForKey:@"bonus_days"];
    }
  
    if (dict[@"available_subscribtions"] != [NSNull null])
    {
        NSArray *arr = dict[@"available_subscribtions"];
        self.availableSubscribtionArr = [NSMutableArray new];
        
        for (NSDictionary *dic in arr) {
            TAvailableSubscribtion *a = [[TAvailableSubscribtion alloc] initWithDictionary:dic];
            [self.availableSubscribtionArr addObject:a];
        }
        
        self.availableSubscribtionCount = self.availableSubscribtionArr.count;
    }

    return self;
}

@end
