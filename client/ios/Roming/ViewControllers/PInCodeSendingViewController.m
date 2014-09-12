//
//  PInCodeSendingViewController.m
//  Rouming
//
//  Created by Karen Ghandilyan on 8/25/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import "PinCodeSendingViewController.h"
#import "PinProcessingService.h"
#import "MBProgressHUD.h"
#import "ResponseObject.h"
#import "SipObject.h"

@interface PinCodeSendingViewController ()<UITextFieldDelegate> {
    float resendTime;
}
@property (nonatomic, strong) NSTimer *resendButtonTimer;

@end

@implementation PinCodeSendingViewController
@synthesize pinCodeField = _pinCodeField;
@synthesize pinCodeLabel = _pinCodeLabel;
@synthesize doneButton = _doneButton;
@synthesize phoneNumber = _phoneNumber;
@synthesize formatedPhoneNumber = _formatedPhoneNumber;

@synthesize resendCounter = _resendCounter;
@synthesize resendButton = _resendButton;
@synthesize resendButtonTimer = _resendButtonTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pinCodeField.hidden = YES;
    self.title = _formatedPhoneNumber;
    _resendButton.enabled = NO;
    [self processResend];
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_pinCodeField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Private Functions
-(void)processResend {
    if (_resendCounter) {
        resendTime = _resendCounter.floatValue;
        
        NSString *formatedTime = [self getFormatedTimeStringForSeconds:resendTime];
        NSString *btnTitle = [NSString stringWithFormat:@"Resend code in %@", formatedTime];
        [_resendButton setTitle:btnTitle forState:UIControlStateDisabled];
        
        _resendButtonTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(processResendTimer) userInfo:nil repeats:YES];
        
    }
}

-(void)processResendTimer {
    --resendTime;
    if (resendTime > 0) {
        NSString *formatedTime = [self getFormatedTimeStringForSeconds:resendTime];
        NSString *btnTitle = [NSString stringWithFormat:@"Resend code in %@", formatedTime];
        [_resendButton setTitle:btnTitle forState:UIControlStateDisabled];

        
    } else {
        _resendButton.enabled = YES;
        resendTime = _resendCounter.floatValue;
        [_resendButtonTimer invalidate];
    }
}

-(NSString *)getFormatedTimeStringForSeconds:(float)secs {
    int minutes = secs / 60;
    int seconds = (int)secs % 60;
    
    NSString *formatedTime = [NSString stringWithFormat:@"%i:%i", minutes, seconds];
    return formatedTime;
}

-(void)fixPinCodeInLabel {
    
    NSMutableArray *letterArray = [NSMutableArray array];
    NSString *letters = _pinCodeField.text;
    [letters enumerateSubstringsInRange:NSMakeRange(0, [letters length])
                                options:(NSStringEnumerationByComposedCharacterSequences)
                             usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                 [letterArray addObject:substring];
                             }];
    
    NSMutableString *str = [[NSMutableString alloc] init];
    for (int i = 0; i < letterArray.count; ++i) {
        if (str.length > 0 ) {
            [str appendString:@"  "];
        }
        NSString *charecter = letterArray[i];
        [str appendString:charecter];
    }
    if (letterArray.count < 4) {
        for (int i = 0 ; i< 4 - letterArray.count; ++i) {
            if (str.length > 0 ) {
                [str appendString:@"  "];
            }
            NSString *charecter = @"_";
            [str appendString:charecter];

        }
    }
    
    _pinCodeLabel.text = str;
}
#pragma mark - IBActions
- (IBAction)resendButtonClicked:(id)sender {
    [self processResend];
    
}
- (IBAction)doneButtonPressed:(id)sender {
    if (_pinCodeField.text.length == 4) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        PinProcessingService *service = [[PinProcessingService alloc] init];
        [service sendPinCodeWithPhoneNumber:_phoneNumber withPinCode:_pinCodeField.text withAppVersion:@"1.0" completion:^(ResponseObject *responseObj, BOOL success, NSString *errorMessage) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (success) {
                if (responseObj.responseData) {
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:responseObj.responseData forKey:SIP_CONNECTION_DETAILS];
                    
                }
            }
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newText.length < 5) {
        _pinCodeField.text = newText;
        [self fixPinCodeInLabel];
    }
    _doneButton.enabled = textField.text.length == 4;
    
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
