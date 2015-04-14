//
//  TPushAccessViewController.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/10/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TPushAccessViewController.h"
#import "TTabBarViewController.h"
#import "cVaxSIPUserAgentEx.h"

@interface TPushAccessViewController ()

@end

@implementation TPushAccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.permission = TPush;
    [self enableAccess];
    self.navigationItem.title = @"Push";
}

- (IBAction)next:(id)sender
{
//    [[cVaxSIPUserAgentEx GetOBJ] InitVaxVoIP:self.appDelegate.telasco.username :@"aaa" :@"login" :self.appDelegate.telasco.password :@"" :@""];
    if (![Utils onlineAccount]) {
        [Utils showAlert:kAppName message:@"Fail"];
    } else {
        TTabBarViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TTabBarViewController"];
        [self presentViewController:vc animated:NO completion:nil];
        vc.selectedIndex = 3;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
