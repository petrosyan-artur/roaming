//
//  UIButton+Telasco.m
//  Telasco
//
//  Created by Telasco Communications on 3/3/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "UIButton+Telasco.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIButton (Telasco)

- (id) init {
    self = [super init];
    if (self != nil) {
        self.exclusiveTouch = YES;
    }
    return self;
}

- (void)roundRect
{
//    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    self.layer.borderColor = kRegisterButtonBorderColor.CGColor;
    self.layer.borderWidth = 0.5f;
}

@end
