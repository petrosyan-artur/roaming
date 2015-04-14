//
//  TCall.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/26/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TCall.h"

@implementation TCall

- (void)initWithDictionary:(NSDictionary *)dic
{
    self.phoneNumber = [dic valueForKey:@"phone"];
    self.duration = [dic valueForKey:@"duration"];
    self.date = [dic valueForKey:@"startDate"];
}

@end
