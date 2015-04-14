//
//  TAccountViewController.h
//  Telasco
//
//  Created by Janna Hakobyan on 4/13/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TBaseViewController.h"

@interface TAccountViewController : TBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *phoneNumberLbl;
@property (nonatomic, weak) IBOutlet UILabel *activeDaysLbl;
@property (nonatomic, weak) IBOutlet UILabel *bonusLbl;
@property (nonatomic, weak) IBOutlet UIButton *accountHistoryBtn;
@property (nonatomic, weak) IBOutlet UIButton *logoutBtn;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
