//
//  TAccountHistoryViewController.m
//  Telasco
//
//  Created by Janna Hakobyan on 4/13/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TAccountHistoryViewController.h"

@interface TAccountHistoryViewController ()

@end

@implementation TAccountHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupWebView];
}

#pragma mark - Private methods

- (void)setupWebView
{
    NSURL *websiteUrl = [NSURL URLWithString:self.urlStr];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [self.webView loadRequest:urlRequest];
}

#pragma mark - UIWebView

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showHUD];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideHUD];
    [self showErrorWithMessage:kFail title:kAppName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
