//
//  TContactDetailCell.h
//  Telasco
//
//  Created by Telasco Communications on 3/20/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TContactDetailCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *phoneNumberLbl;
@property (nonatomic, weak) IBOutlet UILabel *rateLbl;
@property (nonatomic, weak) IBOutlet UIButton *callBtn;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;

@end
