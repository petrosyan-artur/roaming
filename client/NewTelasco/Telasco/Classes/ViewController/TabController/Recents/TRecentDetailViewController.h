//
//  TRecentDetailViewController.h
//  Telasco
//
//  Created by Janna Hakobyan on 4/1/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TBaseViewController.h"
#import "TRecentCall.h"

@interface TRecentDetailViewController : TBaseViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TRecentCall *recentCall;

@end
