//
//  TRecentDetailCell.h
//  Telasco
//
//  Created by Janna Hakobyan on 4/2/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRecentDetailCell : UITableViewCell

//Header
@property (nonatomic, weak) IBOutlet UIImageView *avatarImg;
@property (nonatomic, weak) IBOutlet UILabel *nameLbl;
@property (nonatomic, weak) IBOutlet UILabel *phoneNumberLbl;

//Recent
@property (nonatomic, weak) IBOutlet UILabel *historyLbl;

//PhoneNumbers


- (void)initHeaderWithName:(NSString *)nsme phoneNumber:(NSString *)phoneNumber avatar:(UIImage *)avatar;

@end
