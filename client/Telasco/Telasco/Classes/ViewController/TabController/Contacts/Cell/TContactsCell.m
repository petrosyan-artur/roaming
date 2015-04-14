//
//  TContactsCell.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/18/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TContactsCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TContactsCell

- (void)awakeFromNib {
    self.avatarImg.layer.cornerRadius = 17;
    self.avatarImg.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
