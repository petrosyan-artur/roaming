//
//  PhoneNumberViewController.m
//  Roming
//
//  Created by Karen Ghandilyan on 8/23/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import "PhoneNumberViewController.h"
#import "CountryObject.h"
//#import "CountryCodeProcessingService.h"
#import "PinCodeSendingViewController.h"
#import "PinProcessingService.h"
#import "ResponseObject.h"
#import "MBProgressHUD.h"

@interface PhoneNumberViewController ()<UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) NSNumber *resendCounter;

@end

@implementation PhoneNumberViewController
@synthesize resendCounter = _resendCounter;
@synthesize doneButton = _doneButton;
@synthesize phoneNumberTextField = _phoneNumberTextField;



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

}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_phoneNumberTextField becomeFirstResponder];
}


#pragma mark - Controller Actions
- (IBAction)doneButtonTouched:(id)sender {
     NSString *phoneNumber = [NSString stringWithFormat:@"%@%@",@"+1", _phoneNumberTextField.text];
    
    NSString *alertMessage = [NSString stringWithFormat:@"We will send an SMS with verification code to this number. \n \n %@ \n \n Is it correct?", phoneNumber];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Number Confirmation" message:alertMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"Edit", @"Yes", nil];
    [alertView show];
   
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        NSString *phoneNumber = [NSString stringWithFormat:@"%@%@",@"1", _phoneNumberTextField.text];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        PinProcessingService *service = [[PinProcessingService alloc] init];
        [service requestPinCodeForPhoneNumber:phoneNumber completion:^(ResponseObject *responseObj, BOOL success, NSString *errorMessage) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(responseObj.responseStatus == RESPONSE_STATUS_OK) {
                _resendCounter =  [responseObj.responseData objectForKey:@"next_try"];
                
                [self performSegueWithIdentifier:@"pinRequestPageIdentifier" sender:self];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Somthing goes wrong" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneNumberTextField) {
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        BOOL deleting = [newText length] < [textField.text length];
        
        NSString *stripppedNumber = [newText stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [newText length])];
        NSUInteger digits = [stripppedNumber length];
        
        if (digits > 10)
            stripppedNumber = [stripppedNumber substringToIndex:10];
        
        UITextRange *selectedRange = [textField selectedTextRange];
        NSInteger oldLength = [textField.text length];
        
        if (digits == 0)
            textField.text = @"";
        else if (digits < 3 || (digits == 3 && deleting))
            textField.text = [NSString stringWithFormat:@"(%@", stripppedNumber];
        else if (digits < 6 || (digits == 6 && deleting))
            textField.text = [NSString stringWithFormat:@"(%@) %@", [stripppedNumber substringToIndex:3], [stripppedNumber substringFromIndex:3]];
        else
            textField.text = [NSString stringWithFormat:@"(%@) %@-%@", [stripppedNumber substringToIndex:3], [stripppedNumber substringWithRange:NSMakeRange(3, 3)], [stripppedNumber substringFromIndex:6]];
        
        UITextPosition *newPosition = [textField positionFromPosition:selectedRange.start offset:[textField.text length] - oldLength];
        UITextRange *newRange = [textField textRangeFromPosition:newPosition toPosition:newPosition];
        [textField setSelectedTextRange:newRange];
        
        _doneButton.enabled =( _phoneNumberTextField.text.length == 14);
        
        if (_phoneNumberTextField.text.length > 0) {
            self.title = [NSString stringWithFormat:@"%@%@",@"+1", textField.text];
        } else  {
            self.title = @"Your Phone Number";
        }
        return NO;
    }
    
    return YES;
}
#pragma mark - UINavigtaion
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pinRequestPageIdentifier"]) {
        
        NSString *phoneNumber = [NSString stringWithFormat:@"%@%@",@"1", _phoneNumberTextField.text];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        
        
        
        PinCodeSendingViewController *controller = segue.destinationViewController;
        controller.phoneNumber = phoneNumber;
        controller.formatedPhoneNumber = self.title;
        controller.resendCounter = _resendCounter;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
