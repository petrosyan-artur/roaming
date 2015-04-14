//
//  TResgisterViewController.h
//  Telasco
//
//  Created by Janna Hakobyan on 3/2/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//


#import "TBaseViewController.h"
#import "NIDropDown.h"

@interface TResgisterViewController : TBaseViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIButton *chooseCountryBtn;
@property (nonatomic, weak) IBOutlet UIButton *nextBtn;
@property (nonatomic, weak) IBOutlet UIButton *countryCodeBtn;
@property (nonatomic, weak) IBOutlet UITextField *phoneTF;
@property (nonatomic, weak) IBOutlet UIView *inputPhoneView;
@property (nonatomic, weak) IBOutlet UIImageView *flagImg;

@end
