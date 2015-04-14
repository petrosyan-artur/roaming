//
//  TAccountHistoryViewController.h
//  Telasco
//
//  Created by Janna Hakobyan on 4/13/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TBaseViewController.h"

@interface TAccountHistoryViewController : TBaseViewController <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString *urlStr;

@end
