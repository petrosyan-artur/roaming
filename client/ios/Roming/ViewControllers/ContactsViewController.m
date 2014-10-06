//
//  ContactsViewController.m
//  Rouming
//
//  Created by Karen Ghandilyan on 9/26/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import "ContactsViewController.h"
#import "PhoneContact.h"
#import <AddressBookUI/AddressBookUI.h>

@interface ContactsViewController ()<ABPeoplePickerNavigationControllerDelegate,ABPersonViewControllerDelegate>

@end

@implementation ContactsViewController
//@synthesize contactsTableView = _contactsTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadAllContacts];
    
//    [_contactsTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Functions


-(void)loadAllContacts {
    ABPeoplePickerNavigationController * peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.navigationItem.rightBarButtonItem = nil;
    peoplePicker.peoplePickerDelegate = self;
    // Display only a person's phone and address
    NSArray * displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonAddressProperty],
                                [NSNumber numberWithInt:kABPersonPhoneProperty],
                                nil];
    
    peoplePicker.displayedProperties = displayedItems;
    
    [self.view addSubview:peoplePicker.view];
    [self addChildViewController:peoplePicker];
    [peoplePicker didMoveToParentViewController:self];
}
#pragma mark -ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person {
    ABPersonViewController *view = [[ABPersonViewController alloc] init];
    
    view.personViewDelegate = self;
    view.displayedPerson = person; // Assume person is already defined.
    view.allowsEditing = YES;
    view.allowsActions = NO;
    
    [self.navigationController pushViewController:view animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    return NO;
}


@end
