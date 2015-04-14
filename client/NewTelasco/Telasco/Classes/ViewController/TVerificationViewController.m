//
//  TVerificationViewController.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/2/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TVerificationViewController.h"

@interface TVerificationViewController ()
{
    NSTimer *timer;
    int minutes, seconds;
    int secondsLeft;
}
@end

@implementation TVerificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    secondsLeft = [self.appDelegate.telasco.nextTry intValue];
    [self countdownTimer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.passVerificationTF becomeFirstResponder];
}

- (void)updateCounter:(NSTimer *)theTimer
{
    if(secondsLeft > 0 ){
        secondsLeft --;
        minutes = (secondsLeft % 3600) / 60;
        seconds = (secondsLeft % 3600) % 60;
        self.timerLbl.text = [NSString stringWithFormat:@"Resend code in %02d:%02d", minutes, seconds];
    } else {
        [self stopTimer];
        self.resendBtn.hidden = NO;
        self.timerLbl.hidden = YES;
        secondsLeft = [self.appDelegate.telasco.nextTry intValue];
        minutes = (secondsLeft % 3600) / 60;
        seconds = (secondsLeft % 3600) % 60;
        self.timerLbl.text = [NSString stringWithFormat:@"Resend code in %02d:%02d", minutes, seconds];
    }
}

- (void)countdownTimer
{
    self.resendBtn.hidden = YES;
    self.timerLbl.hidden = NO;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}


#pragma mark - Actions

- (IBAction)resendSMS:(id)sender
{
    if (self.appDelegate.isNetworkReachable) {
        [self showHUD];
        [self.view endEditing:YES];

        [[TNetworking sharedInstance] sendPhoneNumber:[NSString stringWithFormat:@"%@%@",self.appDelegate.telasco.countryCode, self.appDelegate.telasco.phoneNumber] completion:^(NSDictionary *data, NSString *errorStr, NSError *error) {
            
            [self hideHUD];
            [self.passVerificationTF becomeFirstResponder];

            if (error) {
                [self showErrorMessage:[error localizedDescription]];
                return;
            }
            
            if (errorStr) {
                [self showErrorMessage:errorStr];
                return;
            }
            self.appDelegate.telasco.nextTry = [[data valueForKey:@"data"] valueForKey:@"next_try"];
            
            secondsLeft = [self.appDelegate.telasco.nextTry intValue];
            [self countdownTimer];
        }];
    }
}

- (IBAction)next:(id)sender
{
    if (self.appDelegate.isNetworkReachable && self.passLbl1.text.length != 0  && self.passLbl2.text.length != 0 && self.passLbl3.text.length != 0 && self.passLbl4.text.length != 0 ) {
        
        [self showHUD];
        [self.view endEditing:YES];
        [[TNetworking sharedInstance] veridicationCode: [NSString stringWithFormat:@"%@%@",self.appDelegate.telasco.countryCode, self.appDelegate.telasco.phoneNumber] code:self.passVerificationTF.text completion:^(NSDictionary *data, NSString *errorStr, NSError *error) {
            
            [self hideHUD];
            if (error) {
                [self showErrorMessage:[error localizedDescription]];
                [self.passVerificationTF becomeFirstResponder];
                return;
            }
            
            if (errorStr) {
                [self showErrorMessage:errorStr];
                [self.passVerificationTF becomeFirstResponder];
                return;
            }
            
            [self.appDelegate.telasco initWithData:data];
            [self openGetMicrophoneAccess];
        }];
    }
}

- (void)stopTimer
{
    [timer invalidate];
    timer = nil;
}

- (void)openGetMicrophoneAccess
{
    TBaseViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TMicrophoneAccessViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length == 4 && ![string isEqualToString:@""]) {
        return NO;
    }
    
    if (![string isEqualToString:@""]) {
        if ([self.passLbl1.text isEqualToString:@""]) {
            self.passLbl1.text = string;
            return YES;
        }
        
        if (self.passLbl1.text.length == 1 && [self.passLbl2.text isEqualToString:@""]) {
            self.passLbl2.text = string;
            return YES;
        }
        
        if (self.passLbl2.text.length == 1 && [self.passLbl3.text isEqualToString:@""]) {
            self.passLbl3.text = string;
            return YES;
        }
        
        if (self.passLbl3.text.length == 1 && [self.passLbl4.text isEqualToString:@""]) {
            self.passLbl4.text = string;
            return YES;
        }
        
    } else {
        if (self.passLbl4.text.length != 0) {
            self.passLbl4.text = @"";
            return YES;
        }
        if (self.passLbl3.text.length != 0) {
            self.passLbl3.text = @"";
            return YES;
        }
        if (self.passLbl2.text.length != 0) {
            self.passLbl2.text = @"";
            return YES;
        }
        if (self.passLbl1.text.length != 0) {
            self.passLbl1.text = @"";
            return YES;
        }
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
