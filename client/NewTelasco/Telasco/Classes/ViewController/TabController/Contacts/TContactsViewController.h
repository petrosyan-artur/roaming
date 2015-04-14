//
//  TContactsViewController.h
//  Telasco
//
//  Created by Janna Hakobyan on 3/17/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "TBaseViewController.h"
#import "RHAddressBook.h"
#import <AddressBook/AddressBook.h>

@interface TContactsViewController : TBaseViewController <UISearchBarDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    RHAddressBook *addressBook;
    NSMutableArray *peoples;
    NSArray *searchResults;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *searchGrayView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentControl;

@end