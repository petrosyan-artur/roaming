//
//  PInCodeSendingViewController.h
//  Rouming
//
//  Created by Karen Ghandilyan on 8/25/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinCodeSendingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *pinCodeLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, strong) IBOutlet UITextField *pinCodeField;
@property (nonatomic, strong) IBOutlet UIButton *resendButton;

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *formatedPhoneNumber;

@property (nonatomic, assign) NSNumber *resendCounter;
@end
