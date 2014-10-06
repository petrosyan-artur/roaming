//
//  MicrophonePermisionRequestViewController.m
//  Rouming
//
//  Created by Karen Ghandilyan on 9/12/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import "MicrophonePermisionRequestViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MicrophonePermisionRequestViewController ()

@end

@implementation MicrophonePermisionRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)requestMicrophonePermision:(id)sender {
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            // Microphone enabled code
            NSLog(@"Microphone is enabled..");
        }
        else {
            // Microphone disabled code
            NSLog(@"Microphone is disabled..");
        }

        
    }];
    
     [self performSegueWithIdentifier:@"pushNotificationsRequestIdentifer" sender:self];
}

-(IBAction)nextButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"pushNotificationsRequestIdentifer" sender:self];
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
