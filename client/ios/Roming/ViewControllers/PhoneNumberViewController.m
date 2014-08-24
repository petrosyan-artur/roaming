//
//  PhoneNumberViewController.m
//  Roming
//
//  Created by Karen Ghandilyan on 8/23/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import "PhoneNumberViewController.h"
#import "CountryObject.h"
#import "CountryCodeProcessingService.h"
#import "CountryPickerViewController.h"
#import "PinProcessingService.h"
#import "ResponseObject.h"
@interface PhoneNumberViewController ()<UITextFieldDelegate, CountryPickerViewControllerDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) CountryObject *selectedCountry;

//@property (nonatomic, strong) NSArray *countryCodesArray;

@end

@implementation PhoneNumberViewController
@synthesize selectedCountry = _selectedCountry;
@synthesize doneButton = _doneButton;
@synthesize phoneNumberTextField = _phoneNumberTextField;
@synthesize countryCodeButton = _countryCodeButton;
//@synthesize countryCodesArray = _countryCodesArray;

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
    
    [_phoneNumberTextField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    CountryCodeProcessingService *service = [CountryCodeProcessingService sharedInstance];
    
    _selectedCountry = [service getFirstCountry];
    [self.countryCodeButton setTitle:_selectedCountry.dialCode forState:UIControlStateNormal];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_phoneNumberTextField becomeFirstResponder];
}

#pragma mark - UITextFieldEvents
-(void)textFieldDidChange:(UITextField *)textField{
    if (_phoneNumberTextField.text.length) {
        self.title = [NSString stringWithFormat:@"%@%@",_selectedCountry.dialCode, textField.text];
        _doneButton.enabled = YES;
    } else {
        self.title = @"Your Phone Number";
        _doneButton.enabled = NO;
    }
}
#pragma mark - Controller Actions
- (IBAction)doneButtonTouched:(id)sender {
     NSString *phoneNumber = [NSString stringWithFormat:@"%@%@",_selectedCountry.dialCode, _phoneNumberTextField.text];
    
    NSString *alertMessage = [NSString stringWithFormat:@"We will send an SMS with verification code to this number. \n \n %@ \n \n Is it correct?", phoneNumber];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Number Confirmation" message:alertMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"Edit", @"Yes", nil];
    [alertView show];
   
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        NSString *phoneNumber = [NSString stringWithFormat:@"%@%@",_selectedCountry.dialCode, _phoneNumberTextField.text];
        PinProcessingService *service = [[PinProcessingService alloc] init];
        [service requestPinCodeForPhoneNumber:phoneNumber completion:^(ResponseObject *responseObj, BOOL success, NSString *errorMessage) {
            if(responseObj.responseStatus == RESPONSE_STATUS_OK) {
                [self performSegueWithIdentifier:@"pinRequestPageIdentifier" sender:self];
            }
        }];

    }
}

#pragma mark - UINavigtaion
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"selectCountryIdentifier"]) {
        CountryPickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

#pragma mark - CountryPickerViewControllerDelegate
-(void)userSelcetedCountry:(CountryObject *)countryObj {
    if (countryObj) {
        _selectedCountry = countryObj;
        [self.countryCodeButton setTitle:_selectedCountry.dialCode forState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
