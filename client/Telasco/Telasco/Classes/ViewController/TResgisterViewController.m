//
//  TResgisterViewController.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/2/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TResgisterViewController.h"
#import "TVerificationViewController.h"
#import "TCountryListViewController.h"

@interface TResgisterViewController ()
{
    float containerViewY;
}
@end

@implementation TResgisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCustomStyle];
    self.appDelegate.telasco.countryCode = @"1";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTelescoInfo];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (containerViewY == 0) {
        containerViewY = self.containerView.frame.origin.y;
    }
}

#pragma matk - Private methods

- (void)setTelescoInfo
{
    if (self.appDelegate.telasco.isNewChanges) {
        self.appDelegate.telasco.isNewChanges = NO;
        [self.chooseCountryBtn setTitle:self.appDelegate.telasco.country forState:UIControlStateNormal];
        [self.chooseCountryBtn setTitle:self.appDelegate.telasco.country forState:UIControlStateHighlighted];
        [self.countryCodeBtn setTitle:[NSString stringWithFormat:@"+%@", self.appDelegate.telasco.countryCode] forState:UIControlStateNormal];
        self.phoneTF.text = @"";
//        self.flagImg.image = @""
    }
}

- (void)setCustomStyle
{
    [self.chooseCountryBtn roundRect];
    [self.chooseCountryBtn setTitleColor:kGrayTelascoColor forState:UIControlStateNormal];
    [self.chooseCountryBtn setTitleColor:kRedTelascoColor forState:UIControlStateHighlighted];
    [self.nextBtn roundRect];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:kGrayTelascoColor forState:UIControlStateHighlighted];
    self.nextBtn.layer.cornerRadius = 5;
    
    [self.inputPhoneView roundRect];
    [self.countryCodeBtn setTitleColor:kGrayTelascoColor forState:UIControlStateNormal];
    self.phoneTF.textColor = kGrayTelascoColor;
}

- (BOOL)isPhoneNumberValid
{
    if (self.phoneTF.text.length >= 7 && self.phoneTF.text.length <= 14) {
        return YES;
    }
    
    return NO;
}

- (void)openVerificationViewController
{
    if (self.appDelegate.isNetworkReachable) {
        [self showHUD];
        [self.view endEditing:YES];
        [[TNetworking sharedInstance] sendPhoneNumber:[NSString stringWithFormat:@"%@%@",self.appDelegate.telasco.countryCode, self.appDelegate.telasco.phoneNumber] completion:^(NSDictionary *data, NSString *errorStr, NSError *error) {
            
            [self hideHUD];
            if (error) {
                [self showErrorMessage:[error localizedDescription]];
                [self.phoneTF becomeFirstResponder];
                return;
            }
            
            if (errorStr) {
                [self showErrorMessage:errorStr];
                [self.phoneTF becomeFirstResponder];
                return;
            }
            self.appDelegate.telasco.nextTry = [[data valueForKey:@"data"] valueForKey:@"next_try"];
            
            TVerificationViewController *vc = (TVerificationViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"TVerificationViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
}

- (void)openConfirmPhoneNumberView
{
    if (self.appDelegate.isNetworkReachable) {
        [Utils showAlertWithDelegate:self title:@"Number confirmation" message:[NSString stringWithFormat:@"\n\nWe will send SMS with verification code to this number.\n%@ %@ \nIs it correct ?", self.countryCodeBtn.titleLabel.text, self.phoneTF.text] cancelButtonTitle:@"Edit" otherButtonTitle:@"Yes" tag:0];
    }
}

#pragma mark - UITextFieldDelegates

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self moveContainerView];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    CGRect rect = CGRectMake(self.containerView.frame.origin.x, containerViewY, self.containerView.frame.size.width, self.containerView.frame.size.height);
    [self animateViewToRect:rect toDown:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *textWithoutSpace = [self.phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    if (![string isEqualToString:@""] && textWithoutSpace.length > 13) {
        return NO;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray *components = [newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    NSString *decimalString = [components componentsJoinedByString:@""];
    
    NSUInteger length = decimalString.length;
    BOOL hasLeadingOne = length > 0 && [decimalString characterAtIndex:0] == '1';
    
    if (length == 0 || (length > 10 && !hasLeadingOne) || (length > 11)) {
        textField.text = decimalString;
        return NO;
    }
    
    NSUInteger index = 0;
    NSMutableString *formattedString = [NSMutableString string];
    
    
    if (length - index > 3) {
        NSString *areaCode = [decimalString substringWithRange:NSMakeRange(index, 3)];
        [formattedString appendFormat:@"%@ ",areaCode];
        index += 3;
    }
    
    if (length - index > 3) {
        NSString *prefix = [decimalString substringWithRange:NSMakeRange(index, 3)];
        [formattedString appendFormat:@"%@ ",prefix];
        index += 3;
    }
    
    NSString *remainder = [decimalString substringFromIndex:index];
    [formattedString appendString:remainder];
    
    textField.text = formattedString;
    
    return NO;
}

- (void)moveContainerView
{
    float tfH = self.nextBtn.frame.size.height;
    float tfY = [self.nextBtn.superview convertPoint:self.nextBtn.frame.origin toView:nil].y;
    float keyboardY = self.view.frame.size.height - KEYBOARD_HEIGHT;
    
    if ( (tfH + tfY) > keyboardY ) {
        float delta = tfY - tfH - keyboardY;
        CGRect rect = CGRectMake(self.containerView.frame.origin.x, self.containerView.frame.origin.y - delta, self.containerView.frame.size.width, self.containerView.frame.size.height);
        [self animateViewToRect:rect toDown:NO];
    }
}

- (void)animateViewToRect:(CGRect)rect toDown:(BOOL)toDown
{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (toDown) {
                             [self.containerView setFrame:rect];
                         }
                         if (!CGRectEqualToRect(rect, self.containerView.frame)) {
                             [self.containerView setFrame:rect];
                         }
                     }
                     completion:^(BOOL finish) {
                     }
     ];
}


#pragma mark - UIAlertView's delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self.phoneTF becomeFirstResponder];
            break;
        case 1:
            [self openVerificationViewController];
            break;
        default:
            break;
    }
}

#pragma mark - Actions

- (IBAction)next:(id)sender
{
    if (self.phoneTF.text.length == 0) {
        return;
    }
    if (![self isPhoneNumberValid]) {
        return;
    }
    NSString *str1 = [self.phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"+" withString:@""];
    self.appDelegate.telasco.phoneNumber = str2;
    [self openConfirmPhoneNumberView];
}

- (IBAction)selectClicked:(id)sender
{
    [self.view endEditing:YES];
    TCountryListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TCountryListViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
    // Drop down menu
//    NSArray *arr = [[NSArray alloc] init];
//    arr = [NSArray arrayWithObjects:@"Hello 0", @"Hello 1", @"Hello 2", @"Hello 3", @"Hello 4", @"Hello 5", @"Hello 6", @"Hello 7", @"Hello 8", @"Hello 9",nil];
//    NSArray * arrImage = [[NSArray alloc] init];
//    arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], nil];
//    if(dropDown == nil) {
//        CGFloat f = 150;
//        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :arrImage :@"down"];
//        dropDown.delegate = self;
//    }
//    else {
//        [dropDown hideDropDown:sender];
//        [self releaseDropDownMenu];
//    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
