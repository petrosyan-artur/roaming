//
//  PushNotificationsPermisionRequestViewController.m
//  Rouming
//
//  Created by Karen Ghandilyan on 9/12/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import "PushNotificationsPermisionRequestViewController.h"
#import "Constants.h"
@interface PushNotificationsPermisionRequestViewController ()
//@property (nonatomic, assign) BOOL requestedForPush;
@end

@implementation PushNotificationsPermisionRequestViewController
//@synthesize requestedForPush = _requestedForPush;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (_requestedForPush) {
//        [self performSegueWithIdentifier:@"requestForContactsIdentifier" sender:self];
//    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)requestForPushNotifications:(id)sender {
    
//    _requestedForPush = YES;
//    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//    
//    if (types & UIRemoteNotificationTypeAlert) {
//        
//        
//    } else {
    
        UIApplication *application = [UIApplication sharedApplication];
        
//        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            // use registerUserNotificationSettings
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil]];
//        }
    
//        } else {
//            // use registerForRemoteNotifications
//            [application registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//        }
//        
        
        NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
        [userDefs setBool:YES forKey:PUSH_NOTIFICATION_REQUSTED];
        [userDefs synchronize];
        [self performSegueWithIdentifier:@"requestForContactsIdentifier" sender:self];
//    }
    
    
}

-(IBAction)nextButtonPressed:(id)sender {
//    [self performSegueWithIdentifier:@"requestForContactsIdentifier" sender:self];
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
