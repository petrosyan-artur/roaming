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


@interface TKeyPadViewController ()

@end

@implementation TKeyPadViewController

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
    
//    self.blurView.blurRadius = 10;
    self.blurView.alpha = 0;
    [self createKeypad:88 itemWH:74 spaceV:11 spaceH:21];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setExtendedLayoutIncludesOpaqueBars:YES];

//    [self adjustView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

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
}

- (void)createKeypad:(int)containerY itemWH:(int)itemWH spaceV:(int)spaceV spaceH:(int)spaceH
{
    int containerW = (itemWH*3) + (spaceH*2);
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
    [self setStyle:btn0 title:@"0"];
    [self.keypadView addSubview:btn0];
    
//    //call btn
//    Y += itemWH + spaceV;
//    UIButton *callBtn = [[UIButton alloc] initWithFrame:CGRectMake((containerW - itemWH)/2, Y, itemWH-2, itemWH-2)];
//    [self setStyle:callBtn title:@"Call"];
//    [containerView addSubview:callBtn];
    
}

#pragma mark - Actions

- (IBAction)keypadClicked:(UIButton *)sender;
{
    [self.phoneNumberTf setText: [self.phoneNumberTf.text stringByAppendingString:sender.titleLabel.text]];
    self.removeBtn.hidden = (self.phoneNumberTf.text > 0) ? NO : YES;
    [[cVaxSIPUserAgentEx GetOBJ] VaxDigitDTMF:[sender.titleLabel.text intValue]];
}

- (IBAction)onClickCall:(id)sender
{
//    if (self.appDelegate.isNetworkReachable) {
//        int nStatus = [[cVaxSIPUserAgentEx GetOBJ] GetPhoneStatus];
//        
//        if(nStatus == VAX_LINE_STATUS_FREE)
//        {
//            [self BtnDialCall];
            if (self.phoneNumberTf.text.length > 0) {
                [self presentPopinPressed];
            }
//        }
//    }
}

//- (IBAction)onClickDeny:(id)sender
//{
//    if (self.appDelegate.isNetworkReachable) {
//        int nStatus = [[cVaxSIPUserAgentEx GetOBJ] GetPhoneStatus];
//        
//        if(nStatus != VAX_LINE_STATUS_FREE)
//        {
//            [self BtnHangUpCall];
//            [self showKeypadDefault:YES];
//        }
//    }
//}

- (void)showKeypadDefault:(BOOL)isDefaultStyle
{
    if (isDefaultStyle) {
        [UIView animateWithDuration:.4 animations:^{
            self.blurView.alpha = 0;
            self.keypadView.hidden = NO;
            self.keypadView.alpha = 1;
        } completion: ^(BOOL finished) {
            self.blurView.hidden = YES;
        }];
        
    } else {
    }
}


- (void)presentPopinPressed
{
    [self callInNumber:self.phoneNumberTf.text];
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

- (void) BtnDialCall;
{
    if([self.phoneNumberTf.text length] == 0)
    {
//        [VaxVoIP MessageBox: @"Please enter a phone number"];
        return;
    }
    
    if(![[cVaxSIPUserAgentEx GetOBJ] VaxDialCall: self.phoneNumberTf.text])
    {
        [[cVaxSIPUserAgentEx GetOBJ] ErrorMessage];
        return;
    }
}

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

#pragma mark - View lifecycle

- (void) InitOBJ :(NSString*) pPhoneNo;
{
    if(pPhoneNo != NULL && [pPhoneNo length] != 0)
    {
        mPhoneNo = [NSMutableString new];
        [mPhoneNo setString: pPhoneNo];
    }
    else
    {
        mPhoneNo = NULL;
    }
    
    mTimer = NULL;
}

- (void)viewWillAppear:(BOOL)animated
{
    if(mPhoneNo) {
        mPhoneNo = NULL;
    }
    
    [super viewWillAppear:animated];
}

- (void) ClearShowNoDigit :(Boolean) bSaveToo;
{
    if([self.phoneNumberTf.text length] > 0)
    {
        if(bSaveToo == false)
            [self.phoneNumberTf setText: [self.phoneNumberTf.text substringToIndex: [self.phoneNumberTf.text length] - 1]];
        else
            [self.phoneNumberTf SetText: [self.phoneNumberTf.text substringToIndex: [self.phoneNumberTf.text length] - 1]];
    }
    else if(bSaveToo)
    {    self.removeBtn.hidden = YES;

        [self.phoneNumberTf SetText: @""];
    }
}

- (void) OnTimerTick :(NSTimer*) pObjTimer
{
    if(mChangeTickSpeed)
    {
        mChangeTickSpeed = false;
        
        [mTimer invalidate];
        mTimer = NULL;
        
        mTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(OnTimerTick:) userInfo:self repeats: true];
    }
    
    [self ClearShowNoDigit: false];
}

- (IBAction) OnClickRemoveUp:(id)sender;
{
    if(mTimer)
    {
        [mTimer invalidate];
        mTimer = NULL;
    }
    
    [self ClearShowNoDigit: true];
}

- (IBAction) OnClickRemoveDown:(id)sender;
{
    if (self.phoneNumberTf.text.length > 0) {
        [self.phoneNumberTf setText: [self.phoneNumberTf.text substringToIndex: [self.phoneNumberTf.text length] - 1]];
    }
    
    if(mTimer) {
        [mTimer invalidate];
        mTimer = NULL;
    }
    
    mChangeTickSpeed = true;
    
    mTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(OnTimerTick:) userInfo:self repeats: true];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
