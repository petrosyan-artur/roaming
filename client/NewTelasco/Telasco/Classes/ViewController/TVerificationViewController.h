//
//  TVerificationViewController.h
//  Telasco
//
//  Created by Janna Hakobyan on 3/2/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TBaseViewController.h"

@interface TVerificationViewController : TBaseViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *passVerificationTF;
@property (nonatomic, weak) IBOutlet UILabel *passLbl1;
@property (nonatomic, weak) IBOutlet UILabel *passLbl2;
@property (nonatomic, weak) IBOutlet UILabel *passLbl3;
@property (nonatomic, weak) IBOutlet UILabel *passLbl4;
@property (nonatomic, weak) IBOutlet UILabel *timerLbl;
@property (nonatomic, weak) IBOutlet UIButton *resendBtn;
@property (nonatomic, weak) IBOutlet UIButton *nextBtn;

@end
