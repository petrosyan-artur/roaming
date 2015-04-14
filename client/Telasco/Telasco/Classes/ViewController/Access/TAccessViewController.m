//
//  TAccessViewController.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/10/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TAccessViewController.h"
#import "TAccessManager.h"
#import "TTabBarViewController.h"

@interface TAccessViewController ()

@end

@implementation TAccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nextBtn.exclusiveTouch = YES;
}

- (void)enableAccess
{
    switch (self.permission) {
        case TPush:
            
            break;
            
        case TContacts:
            [[TAccessManager sharedInstance] enabledContactsAccess];
            break;
            
        case TMicrophone:
            [[TAccessManager sharedInstance] enabledMicrophoneAccess];
            break;
            
        default:
            break;
    }
}

- (IBAction)next:(id)sender
{
    switch (self.permission) {
        case TPush: {
            TTabBarViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TTabBarViewController"];
            [self presentViewController:vc animated:NO completion:nil];
            self.appDelegate.window.rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        }
            break;
            
        case TContacts: {
            TAccessViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TPushAccessViewController"];
            [self.navigationController pushViewController:vc animated:YES];
            }
            break;
            
        case TMicrophone: {
                TAccessViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TContactAccessViewController"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
