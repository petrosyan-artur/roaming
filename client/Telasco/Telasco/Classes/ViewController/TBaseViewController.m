//
//  TBaseViewController.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/2/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TBaseViewController.h"
#import "TKeypadDetailViewController.h"

@interface TBaseViewController ()
{
    MBProgressHUD *mBProgressHUD;
    MBProgressHUD *errorProgressHUD;
    UIView *noInetView;
}
@end

@implementation TBaseViewController



- (void)viewDidLoad 
{
    [super viewDidLoad];
    for (UIView *temp in self.navigationController.navigationBar.subviews) {
        [temp setExclusiveTouch:YES];
    }
    
    self.appDelegate = [AppDelegate sharedInstance];
    [self initProgressHud];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventHandler:) name:kInternetStateChanges object:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (!noInetView) {
        [self initNoInternetBottomView];
    }
    [self.view layoutIfNeeded];
}

#pragma mark - Private methods

- (void)initProgressHud
{
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    mBProgressHUD = [[MBProgressHUD alloc] initWithView:keyWindow];
    [self.view addSubview:mBProgressHUD];
    [mBProgressHUD setDelegate:self];
}

- (void)showErrorWithMessage:(NSString *)message title:(NSString *)title
{
//    errorProgressHUD = [[MBProgressHUD alloc] init ];//]WithView:self.view.window];
//    [[[UIApplication sharedApplication] keyWindow] addSubview:errorProgressHUD];
//    //    errorProgressHUD.frame = CGRectMake(errorProgressHUD.frame.origin.x, errorProgressHUD.frame.origin.y-60, errorProgressHUD.frame.size.width, errorProgressHUD.frame.size.height);
//    errorProgressHUD.labelFont = [UIFont fontWithName:PNFontBold size:17];
//    errorProgressHUD.labelText = title;
//    errorProgressHUD.detailsLabelText = message;
//    errorProgressHUD.mode = MBProgressHUDModeCustomView;
//    errorProgressHUD.detailsLabelFont = [UIFont fontWithName:PNFontReg size:13];
//    [errorProgressHUD hide:YES afterDelay:1.0];
//    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    //    [self.view addSubview:errorProgressHUD];
//    [errorProgressHUD setDelegate:self];
//    [errorProgressHUD show:YES];
//    [self.view bringSubviewToFront:errorProgressHUD];
    
    [Utils showAlert:title message:message];
}

#pragma mark - Hud

- (void)showHUD
{
    [mBProgressHUD show:YES];
    [self.view bringSubviewToFront:mBProgressHUD];
}


- (void)hideHUD
{
    [mBProgressHUD hide:YES];
}

- (void)popViewControllerAfterDelay:(float)delayInSeconds
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)initNoInternetBottomView
{
    noInetView = [[UIView alloc] initWithFrame:CGRectMake(0, -30, self.view.frame.size.width, 30)];
    noInetView.backgroundColor = [kRedTelascoColor colorWithAlphaComponent:0.7];
    [self.view addSubview:noInetView];
    
    UILabel *noInetLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, noInetView.frame.size.height)];
    noInetLbl.textAlignment = NSTextAlignmentCenter;
    noInetLbl.text = @"Network error";
    noInetLbl.textColor = [UIColor whiteColor];
    [noInetLbl setFont:[UIFont fontWithName:PNFontBold size:16]];
    [noInetView addSubview:noInetLbl];
    
    noInetView.hidden = YES;
}

- (void)showNoInternerBottomView
{
    if (noInetView.frame.origin.y == 0) {
        return;
    }
    
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        noInetView.hidden = NO;
        noInetView.frame  = CGRectMake(0, 0, noInetView.frame.size.width, noInetView.frame.size.height);
        
    } completion:^(BOOL finished) { }];
}

- (void)hideNoInternerBottomView
{
    if (noInetView.frame.origin.y == -30) {
        return;
    }
    
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        noInetView.frame  = CGRectMake(0, -30, noInetView.frame.size.width, noInetView.frame.size.height);
        
    } completion:^(BOOL finished) {
        noInetView.hidden = YES;
    }];
}

- (void)showErrorMessage:(NSString *)errorStr
{
    if (errorStr) {
//        if ([errorStr isEqualToString:@"invalidToken"]) {
//            [Utils showAlertWithDelegate:self message:kOtherwiseCancelToRejectTheAction tag:666];
//        } else {
            [self showErrorWithMessage:errorStr title:kAppName];
//        }
    }
}

#pragma mark - NSNotification's handler

- (void)eventHandler:(NSNotification *)notification
{
    if (self.appDelegate.isNetworkReachable) {
        [self hideNoInternerBottomView];
    } else {
        [self showNoInternerBottomView];
    }
}

- (void)callInNumber:(NSString *)phoneNumber
{
    TKeypadDetailViewController *vc = (TKeypadDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"TKeypadDetailViewController"];
    [vc setPopinTransitionStyle:BKTPopinTransitionStyleCrossDissolve];
    [vc setPopinOptions:BKTPopinDefault];
    [vc setPopinAlignment:BKTPopinAlignementOptionCentered];
    
    //    Create a blur parameters object to configure background blur
    //    BKTBlurParameters *blurParameters = [BKTBlurParameters new];
    //    blurParameters.alpha = 1.0f;
    //    blurParameters.radius = 8.0f;
    //    blurParameters.saturationDeltaFactor = 1.8f;
    //    blurParameters.tintColor = [UIColor colorWithRed:56/255.0f green:93/255.0f blue:125/255.0f alpha:.4f];
    //    [vc setBlurParameters:blurParameters];
    //
    //    //Add option for a blurry background
    //    [vc setPopinOptions:[vc popinOptions]|BKTPopinBlurryDimmingView];
    //
    //    //Define a custom transition style
    //    if (vc.popinTransitionStyle == BKTPopinTransitionStyleCustom)
    //    {
    //        [vc setPopinCustomInAnimation:^(UIViewController *popinController, CGRect initialFrame, CGRect finalFrame) {
    //
    //            popinController.view.frame = finalFrame;
    //            popinController.view.transform = CGAffineTransformMakeRotation(M_PI_4 / 2);
    //
    //        }];
    //
    //        [vc setPopinCustomOutAnimation:^(UIViewController *popinController, CGRect initialFrame, CGRect finalFrame) {
    //
    //            popinController.view.frame = finalFrame;
    //            popinController.view.transform = CGAffineTransformMakeRotation(M_PI_2);
    //
    //        }];
    //    }
    
    [vc setPreferedPopinContentSize:CGSizeMake(self.appDelegate.window.frame.size.width, self.appDelegate.window.frame.size.height)];
    [vc setPopinTransitionDirection:BKTPopinTransitionDirectionTop];
    vc.phoneNumber = phoneNumber;
    [self presentPopinController:vc animated:YES completion:^{
        NSLog(@"Popin presented !");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
