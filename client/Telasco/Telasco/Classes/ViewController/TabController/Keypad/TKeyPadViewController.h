//
//  TKeyPadViewController.h
//  Telasco
//
//  Created by Janna Hakobyan on 3/10/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TBaseViewController.h"
#import "FXBlurView.h"
#import "cUITextFieldEx.h"

@interface TKeyPadViewController : TBaseViewController
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
    
    UIActionSheet *mActionSheet;
    NSMutableString *mpIncomingCallerId;
}

@property (nonatomic, weak) IBOutlet cUITextFieldEx *phoneNumberTf;
@property (nonatomic, weak) IBOutlet UIButton *removeBtn;
@property (nonatomic, weak) IBOutlet UIView *blurView;
@property (nonatomic, weak) IBOutlet UIButton *denyBtn;
@property (nonatomic, weak) IBOutlet UIButton *muteBtn;
@property (nonatomic, weak) IBOutlet UIButton *keypadBtn;
@property (nonatomic, weak) IBOutlet UIButton *speakerBtn;
@property (nonatomic, weak) IBOutlet UILabel *contactNameLbl;

@property (nonatomic, weak) IBOutlet UIButton *callBtn;
@property (nonatomic, weak) IBOutlet UIView *keypadView;
@property (nonatomic, weak) IBOutlet UIView *muteView;

@end
