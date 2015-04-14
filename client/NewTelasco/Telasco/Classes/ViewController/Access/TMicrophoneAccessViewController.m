//
//  TMicrophoneAccessViewController.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/9/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TMicrophoneAccessViewController.h"
#import "TAccessManager.h"

@implementation TMicrophoneAccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.permission = TMicrophone;
    self.navigationItem.title = @"Microphone";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self enableAccess];
}

@end
