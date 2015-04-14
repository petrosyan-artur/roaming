//
//  TContactsDetailViewController.h
//  Telasco
//
//  Created by Janna Hakobyan on 3/18/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TBaseViewController.h"
#import "RHPerson.h"

@interface TContactsDetailViewController : TBaseViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) RHPerson *person;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImg;
@property (nonatomic, strong) UIImageView *coverImg;
@property (nonatomic, strong) UIImageView *avatarOriginalImg;
@property (nonatomic) CGRect cachedCoverImageViewSize;
@property (nonatomic) CGRect cachedAvatarImageViewSize;
@property (nonatomic, weak) IBOutlet UILabel *nameLbl;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end
