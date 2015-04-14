//
//  TRecentCallCell.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/25/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TRecentCallCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TRecentCallCell

- (void)awakeFromNib {
    self.avatarImg.layer.cornerRadius = 17;
    self.avatarImg.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initWithDictionary:(NSDictionary *)dic
{
    self.phoneNumberLbl.text = [dic valueForKey:@"phone"];
//    self.dateLbl.text = [dic valueForKey:@"startDate"];
}

- (void)initWithName:(NSString *)name phoneNumber:(NSString *)phoneNumber avatar:(UIImage *)avatar ringCount:(int)ringCount date:(NSString *)date
{
    self.avatarImg.image  = (avatar) ? avatar : [UIImage imageNamed:@"avatar"];
//    self.dateLbl.text = date;
    self.phoneNumberLbl.text = (name) ? name : phoneNumber;
}

@end
