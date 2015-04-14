//
//  TBaseViewController.h
//  Telasco
//
//  Created by Janna Hakobyan on 3/2/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIViewController+MaryPopin.h"

@interface TBaseViewController : UIViewController <MBProgressHUDDelegate>

@property (nonatomic, strong) AppDelegate *appDelegate;

- (void)showHUD;
- (void)hideHUD;
- (void)popViewControllerAfterDelay:(float)delayInSeconds;
- (void)showErrorWithMessage:(NSString *)message title:(NSString *)title;
- (void)showNoInternerBottomView;
- (void)hideNoInternerBottomView;
- (void)showErrorMessage:(NSString *)errorStr;
- (void)callInNumber:(NSString *)phoneNumber;

@end
