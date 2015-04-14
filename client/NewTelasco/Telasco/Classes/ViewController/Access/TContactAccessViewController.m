//
//  TContactAccessViewController.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/9/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TContactAccessViewController.h"

@implementation TContactAccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.permission = TContacts;
    self.navigationItem.title = @"Contacts";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self enableAccess];
}

@end
