 //
//  TKeyPadViewController.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/10/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TKeyPadViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "cVaxSIPUserAgentEx.h"
#import "TKeypadDetailViewController.h"

#define kTopPadding 15
#define kTextFieldH 26
#define kTextFieldKeypadSpace 25
#define kKeypadVerticalItemsSpace     10
#define kKeypadCallBtnSpace   12
#define kBottomPadding        17

#define kKeypadTrailingSpase  29
#define kKeypadHorizontalItemsSpace   19

#define kPhoneNumberLenghtForRate 7

@interface TKeyPadViewController ()
{
    BOOL isStartGetRate;
    BOOL isRateFind;
}
@end

@implementation TKeyPadViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    m_nLastStatusId = VAX_REG_STATUS_OFFLINE;
    m_bLastStatusError = false;
    
    mLastStatusPhrase = [NSMutableString new];
    [mLastStatusPhrase setString: @"REGISTER_STATUS_OFFLINE"];
    
    [[cVaxSIPUserAgentEx GetOBJ] SetPhoneDetailTableView: self];
    mpIncomingCallerId = [NSMutableString new];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0f green:231/255.0f blue:238/255.0f alpha:1.0f];
    self.phoneNumberTf.userInteractionEnabled = NO;
    
    m_nLastStatusId = VAX_REG_STATUS_OFFLINE;
    m_bLastStatusError = false;
    
    mLastStatusPhrase = [NSMutableString new];
    [mLastStatusPhrase setString: @REGISTER_STATUS_OFFLINE];
    
    mpIncomingCallerId = [NSMutableString new];
    
    [self.phoneNumberTf attachTapHandler];
    self.phoneNumberTf.delegate = self;
    
//    self.blurView.blurRadius = 10;
//    self.blurView.alpha = 0;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (!self.keypadView) {
//        [self createKeypad:88 itemWH:74 spaceV:11 spaceH:21];
        [self createKeypad:105 itemWH:74 spaceV:11 spaceH:21];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    if(mPhoneNo) {
        mPhoneNo = NULL;
    }
    
    [super viewWillAppear:animated];
}

#pragma mark - Private methods

- (void)setStyle:(UIButton *)btn title:(NSString *)title
{
    btn.layer.cornerRadius = btn.frame.size.width/2;
    btn.layer.borderWidth = 1.5f;
    btn.clipsToBounds = YES;
    btn.layer.borderColor = [UIColor colorWithRed:81/255.0f green:116/255.0f blue:143/255.0f alpha:1.0f].CGColor;
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitleColor:[UIColor colorWithRed:11/255.0f green:11/255.0f blue:15/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:36]];

    [btn addTarget:self action:@selector(keypadClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([title isEqualToString:@"0"]) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnPlus:)];
        longPress.minimumPressDuration = 0.5;
        longPress.delegate = self;
        [btn addGestureRecognizer:longPress];
    }
}

- (void)createKeypad:(int)containerY itemWH:(int)itemWH spaceV:(int)spaceV spaceH:(int)spaceH
{
    int containerW = (itemWH*3) + (spaceH*2);
    self.keypadView = [UIView new];
    [self.view addSubview:self.keypadView];
    self.keypadView.frame = CGRectMake((self.view.frame.size.width - containerW )/2, containerY, containerW, (itemWH*5) + (spaceV*4));
    self.keypadView.backgroundColor = [UIColor clearColor];
   
    int Y = 0;
    int index = 1;
    
    for (int i=0; i<3; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((i*itemWH) + (i* spaceH), Y, itemWH, itemWH)];
        [self setStyle:btn title:[NSString stringWithFormat:@"%i", index++]];
        [self.keypadView addSubview:btn];
    }
  
    Y += itemWH + spaceV;
    for (int i=0; i<3; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((i*itemWH) + (i* spaceH), Y, itemWH, itemWH)];
        [self setStyle:btn title:[NSString stringWithFormat:@"%i", index++]];
        [self.keypadView addSubview:btn];
    }
    
    Y += itemWH + spaceV;
    for (int i=0; i<3; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((i*itemWH) + (i* spaceH), Y, itemWH, itemWH)];
        [self setStyle:btn title:[NSString stringWithFormat:@"%i", index++]];
        [self.keypadView addSubview:btn];
    }
    
    //0
    Y += itemWH + spaceV;
    UIButton *btn0 = [[UIButton alloc] initWithFrame:CGRectMake((containerW - itemWH)/2, Y, itemWH, itemWH)];
    btn0.backgroundColor = [UIColor blueColor];
    [btn0 setTitleColor:[UIColor colorWithRed:11/255.0f green:11/255.0f blue:15/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [btn0 setTitle:@"0" forState:UIControlStateNormal];
    [self setStyle:btn0 title:@"0"];
    [self.keypadView addSubview:btn0];
    
//    //call btn
//    Y += itemWH + spaceV;
//    UIButton *callBtn = [[UIButton alloc] initWithFrame:CGRectMake((containerW - itemWH)/2, Y, itemWH-2, itemWH-2)];
//    [self setStyle:callBtn title:@"Call"];
//    [containerView addSubview:callBtn];
    
}

- (void)getRate:(NSString *)phone
{
    NSString *pn = [[phone componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    NSArray *arr = @[pn];
    [[TNetworking sharedInstance] getRate:arr completion:^(NSDictionary *data, NSString *errorStr, NSError *error) {
        if (error) {
            [self showErrorMessage:[error localizedDescription]];
            return;
        }
        
        if (errorStr) {
            [self showErrorMessage:errorStr];
            return;
        }
        
        int i = [[[[data valueForKey:@"rates"] valueForKey:phone] valueForKey:@"rate"] intValue];
        
        if (i == 0) {
            self.rateLbl.text = [NSString stringWithFormat:@"%@ %@", [[[data valueForKey:@"rates"] valueForKey:phone] valueForKey:@"location"], [[[data valueForKey:@"rates"] valueForKey:phone] valueForKey:@"rate"]];
            isRateFind = YES;
        }
    }];
}


#pragma mark - Actions

- (void)longPressOnPlus:(id)sender
{
    if (self.phoneNumberTf.text.length == 0) {
        [self.phoneNumberTf setText: [self.phoneNumberTf.text stringByAppendingString:@"+"]];
        self.removeBtn.hidden = (self.phoneNumberTf.text > 0) ? NO : YES;
        [[cVaxSIPUserAgentEx GetOBJ] VaxDigitDTMF:[@"11" intValue]];
    }
}

- (IBAction)keypadClicked:(UIButton *)sender
{
    [self.phoneNumberTf setText:[self.phoneNumberTf.text stringByAppendingString:sender.titleLabel.text]];
    self.removeBtn.hidden = (self.phoneNumberTf.text > 0) ? NO : YES;
    [[cVaxSIPUserAgentEx GetOBJ] VaxDigitDTMF:[sender.titleLabel.text intValue]];
    
    if ( ([self.phoneNumberTf.text hasPrefix:@"+"] || [self.phoneNumberTf.text hasPrefix:@"00"] || [self.phoneNumberTf.text hasPrefix:@"011"]) && self.phoneNumberTf.text.length == kPhoneNumberLenghtForRate && !isStartGetRate && !isRateFind) {
        isStartGetRate = YES;
        [self getRate:self.phoneNumberTf.text];
    }
}

- (IBAction)onClickCall:(id)sender
{
    if (self.phoneNumberTf.text.length > 0) {
        if ([Utils isCorrectNumberFormat:self.phoneNumberTf.text]) {
            [self presentPopinPressed];
        } else {
            [Utils showAlert:kAppName message:kInvalidNumberFormat];
        }
    }
}

- (void)presentPopinPressed
{
    [self callInNumber:self.phoneNumberTf.text originPhoneNumber:self.phoneNumberTf.text parent:self];
}

- (IBAction)onClickKeypad:(id)sender
{

}

- (IBAction)onClickSpeaker:(id)sender
{
    [[cVaxSIPUserAgentEx GetOBJ] VaxSetSpeakerPhoneState:![[cVaxSIPUserAgentEx GetOBJ] VaxGetSpeakerPhoneState]];
}

- (IBAction)onClickMute:(id)sender
{
    [[cVaxSIPUserAgentEx GetOBJ] VaxSetMuteMic:![[cVaxSIPUserAgentEx GetOBJ] VaxGetMuteMic]];
}

#pragma mark - Remove PhoneNumber

- (void)clearShowNoDigit
{
    if ([self.phoneNumberTf.text length] > 0) {
        [self.phoneNumberTf setText: [self.phoneNumberTf.text substringToIndex: [self.phoneNumberTf.text length] - 1]];
    }
    if ([self.phoneNumberTf.text length] == 0) {
        self.removeBtn.hidden = YES;
        [self.phoneNumberTf setText: @""];
    }
    if ([self.phoneNumberTf.text length] < 6) {
        isStartGetRate = NO;
        isRateFind = NO;
        self.rateLbl.text = @"";
    }
}

- (void)onTimerTick:(NSTimer *)pObjTimer
{
    if (mChangeTickSpeed) {
        mChangeTickSpeed = false;
        
        [mTimer invalidate];
        mTimer = NULL;
        
        mTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(onTimerTick:) userInfo:self repeats: true];
    }
    
    [self clearShowNoDigit];
}

- (IBAction)onClickRemoveUp:(id)sender;
{
    if (mTimer) {
        [mTimer invalidate];
        mTimer = NULL;
    }
    
    [self clearShowNoDigit];
}

- (IBAction)onClickRemoveDown:(id)sender;
{
    if (mTimer) {
        [mTimer invalidate];
        mTimer = NULL;
    }
    
    mChangeTickSpeed = true;
    
    mTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(onTimerTick:) userInfo:self repeats: true];
}



- (void)pasteDone:(NSString*)pasteString
{
    if (pasteString) {
        
        NSString *pn = [[pasteString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
        
        NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([pn rangeOfCharacterFromSet:notDigits].location == NSNotFound) {    // only digits
            self.phoneNumberTf.text = [NSString stringWithFormat:@"%@%@", self.phoneNumberTf.text, pn];
        }
    }
}

- (void)textBecameEmpty
{
    
}
- (void)textBecameNotEmpty
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
