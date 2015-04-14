//
//  PhoneNumberLabel.h
//  Telasco
//
//  Created by Janna Hakobyan on 4/13/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelDelegate.h"

@interface PhoneNumberLabel : UILabel

@property (retain, nonatomic) id<LabelDelegate> delegate;

- (void)attachTapHandler;

@end
