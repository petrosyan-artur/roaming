//
//  TRecentsViewController.h
//  Telasco
//
//  Created by Janna Hakobyan on 3/25/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TBaseViewController.h"

@interface TRecentsViewController : TBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
