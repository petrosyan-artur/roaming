//
//  TRecentDetailCell.m
//  Telasco
//
//  Created by Janna Hakobyan on 4/2/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TRecentDetailCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TRecentDetailCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initHeaderWithName:(NSString *)name phoneNumber:(NSString *)phoneNumber avatar:(UIImage *)avatar
{
    self.avatarImg.image = (avatar) ? avatar : [UIImage imageNamed:@"avatar"];
    self.avatarImg.layer.cornerRadius = 30;
    self.avatarImg.clipsToBounds = YES;

    if (!name) {
//        self.phoneNumberLbl.frame = CGRectMake(self.phoneNumberLbl.frame.origin.x, self.avatarImg.frame.origin.y+(self.avatarImg.frame.size.height/2), self.phoneNumberLbl.frame.size.width, self.phoneNumberLbl.frame.size.height);
        self.nameLbl.text = phoneNumber;
        self.phoneNumberLbl.hidden = YES;
    } else {
        self.nameLbl.text = name;
        self.phoneNumberLbl.text = phoneNumber;
    }
}

@end
