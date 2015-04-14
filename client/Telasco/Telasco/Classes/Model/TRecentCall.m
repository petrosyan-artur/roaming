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
    }
    
    return self;
}

@end
