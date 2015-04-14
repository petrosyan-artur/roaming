//
//  TKeypadDetailViewController.h
//  Telasco
//
//  Created by Janna Hakobyan on 3/16/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TBaseViewController.h"

@interface TKeypadDetailViewController : TBaseViewController
{
    IBOutlet UILabel *mStatusField;
    
    BOOL mbButtonHoldEnabled;
    BOOL mbButtonContactsEnabled;
    
    NSTimer *mTimer;
    Boolean mChangeTickSpeed;
    
    NSMutableString *mPhoneNo;
    
    NSMutableString *mLastStatusPhrase;
    int m_nLastStatusId;
    Boolean m_bLastStatusError;
}

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *originalPhone;
@property (nonatomic, weak) IBOutlet UILabel *phoneNumberLbl;
@property (nonatomic, weak) IBOutlet UIView *keypadView;
@property (nonatomic, weak) IBOutlet UIButton *btn0;
@property (nonatomic, weak) IBOutlet UIButton *btn1;
@property (nonatomic, weak) IBOutlet UIButton *btn2;
@property (nonatomic, weak) IBOutlet UIButton *btn3;
@property (nonatomic, weak) IBOutlet UIButton *btn4;
@property (nonatomic, weak) IBOutlet UIButton *btn5;
@property (nonatomic, weak) IBOutlet UIButton *btn6;
@property (nonatomic, weak) IBOutlet UIButton *btn7;
@property (nonatomic, weak) IBOutlet UIButton *btn8;
@property (nonatomic, weak) IBOutlet UIButton *btn9;
@property (nonatomic, weak) IBOutlet UIButton *btnD;
@property (nonatomic, weak) IBOutlet UIButton *btnS;
@property (nonatomic, weak) IBOutlet UIButton *hideKeypadBtn;

@end
