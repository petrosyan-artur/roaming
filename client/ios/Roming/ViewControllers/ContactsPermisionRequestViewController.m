//
//  ContactsPermisionRequestViewController.m
//  Rouming
//
//  Created by Karen Ghandilyan on 9/12/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import "ContactsPermisionRequestViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "AppDelegate.h"
@interface ContactsPermisionRequestViewController ()

@end

@implementation ContactsPermisionRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)requestForContactsPermission:(id)sender {
    // Request to authorise the app to use addressbook
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(nil, nil);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // If the app is authorized to access the first time then add the contact
//                [self _addContactToAddressBook];
            } else {
                // Show an alert here if user denies access telling that the contact cannot be added because you didn't allow it to access the contacts
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // If the user user has earlier provided the access, then add the contact
//        [self _addContactToAddressBook];
    }
    else {
        // If the user user has NOT earlier provided the access, create an alert to tell the user to go to Settings app and allow access
    }
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate switchToCallView];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
