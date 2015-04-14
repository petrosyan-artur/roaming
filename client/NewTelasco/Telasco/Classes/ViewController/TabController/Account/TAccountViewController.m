//
//  TAccountViewController.m
//  Telasco
//
//  Created by Janna Hakobyan on 4/13/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TAccountViewController.h"
#import "TAccountCell.h"
#import "TAccount.h"
#import "TAvailableSubscribtion.h"
#import "TAccountHistoryViewController.h"

@interface TAccountViewController ()
{
    TAccount *account;
}
@end

@implementation TAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getAccountInfo];
    self.indicator.hidden = YES;
}

#pragma mark - Private methods

- (void)setInfo:(NSDictionary *)dic
{
    self.phoneNumberLbl.text = [NSString stringWithFormat:@"+%@%@", [Utils readFromUserDefaults:kCountryCode], [Utils readFromUserDefaults:kPhoneNumber]];
    
    account = [[TAccount alloc] initWithDictionary:dic];
    self.activeDaysLbl.text = [NSString stringWithFormat:@"Active days: %@", account.activeDays];
    self.bonusLbl.text = [NSString stringWithFormat:@"Bonus days: %@", account.bonusDays];
    [self.tableView reloadData];
    
    self.tableView.hidden = NO;
    self.accountHistoryBtn.hidden = NO;
    self.logoutBtn.hidden = NO;
}

- (void)getAccountInfo
{
    if (self.appDelegate.isNetworkReachable) {
        [self showHUD];
        
        [[TNetworking sharedInstance] getAccountInfo:^(NSDictionary *data, NSString *errorStr, NSError *error) {
            
            [self hideHUD];
            if (error) {
                [self showErrorMessage:[error localizedDescription]];
                return;
            }
            
            if (errorStr) {
                [self showErrorMessage:errorStr];
                return;
            }
            
            [self setInfo:data];
        }];
    }
}

#pragma mark - Actions

- (IBAction)openAccountHistory:(id)sender
{
    TAccountHistoryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TAccountHistoryViewController"];
    vc.urlStr = @"http://37.48.84.64/api/user/account-history";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)getNewDays:(UIButton *)sender
{
    TAccountHistoryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TAccountHistoryViewController"];
    TAvailableSubscribtion *subscribtion = account.availableSubscribtionArr[sender.tag];
    vc.urlStr = subscribtion.url;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)logout:(id)sender
{
    if (self.appDelegate.isNetworkReachable) {
        self.indicator.hidden = NO;
        [self.indicator startAnimating];
        
        [[TNetworking sharedInstance] logout:^(NSDictionary *data, NSString *errorStr, NSError *error) {
          
            if (error) {
                [self showErrorMessage:[error localizedDescription]];
                return;
            }
            
            if (errorStr) {
                [self showErrorMessage:errorStr];
                return;
            }
            [self logout];
        }];
    }
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return account.availableSubscribtionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TAccountCell *cell = (TAccountCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil) {
        cell = [[TAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    TAvailableSubscribtion *data = account.availableSubscribtionArr[indexPath.row];
    [cell.getDaysBtn setTitle:[NSString stringWithFormat:@"%@ Add %@", data.price, data.duration] forState:UIControlStateNormal];
    [cell.getDaysBtn setTitleColor:kSelectedBuleColor forState:UIControlStateHighlighted];
    [cell.getDaysBtn addTarget:self action:@selector(getNewDays:) forControlEvents:UIControlEventTouchUpInside];
    cell.getDaysBtn.tag = indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
