//
//  TRecentCallCell.h
//  Telasco
//
//  Created by Janna Hakobyan on 3/25/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface TRecentCallCell : MGSwipeTableCell

@property (nonatomic, weak) IBOutlet UIImageView *avatarImg;
@property (nonatomic, weak) IBOutlet UILabel *phoneNumberLbl;
@property (nonatomic, weak) IBOutlet UILabel *dateLbl;
@property (nonatomic, weak) IBOutlet UIButton *infoBtn;

- (void)initWithName:(NSString *)name phoneNumber:(NSString *)phoneNumber avatar:(UIImage *)avatar ringCount:(int)ringCount date:(NSString *)date;

@end
