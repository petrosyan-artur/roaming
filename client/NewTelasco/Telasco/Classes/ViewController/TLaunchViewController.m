//
//  TLaunchViewController.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/12/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TLaunchViewController.h"
#import "TTabBarViewController.h"
#import "TResgisterViewController.h"

@interface TLaunchViewController ()

@end

@implementation TLaunchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)setup
{
    if ([[Utils readFromUserDefaults:kLogined] isEqualToString:kYes]) {
        [self.appDelegate.telasco update];
        if (![Utils onlineAccount]) {
            [Utils showAlert:kAppName message:@"Fail"];
        } else {
            TTabBarViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TTabBarViewController"];
            [self.appDelegate.window setRootViewController:vc];
            vc.selectedIndex = 3;
        }
    } else {
        UINavigationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TRegisterNavigationController"];
        [self.appDelegate.window setRootViewController:vc];
    }
}

- (IBAction)retry:(id)sender
{
    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
