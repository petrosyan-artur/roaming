//
//  TRecentCall.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/26/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TRecentCall.h"

@implementation TRecentCall

- (id)init
{
    self = [super init];
    if (self) {
        self.call = [TCall new];
        self.calls = [NSMutableArray new];
    }
    
    return self;
}

- (void)updateData
{
    [self.calls insertObject:self.call atIndex:0];
}

- (int)ringCount
{
    return (int)self.calls.count;
}

@end
