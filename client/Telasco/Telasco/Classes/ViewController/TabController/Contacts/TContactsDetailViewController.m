//
//  TContactsDetailViewController.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/18/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TContactsDetailViewController.h"
#import "TContactDetailCell.h"
#import <QuartzCore/QuartzCore.h>

@interface TContactsDetailViewController ()
{
    NSMutableArray *phones;
    NSMutableArray *modifidedPhones;
    NSMutableArray *rates;
}
@end

@implementation TContactsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    modifidedPhones = [NSMutableArray new];
    rates = [NSMutableArray new];
    RHMultiValue *p = (RHMultiValue *)self.person.phoneNumbers.values;
    phones = (NSMutableArray *)p;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self configCoverImage];
    [self adjustCoverImage:0.5];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupInfo];
    for (NSString *p in phones) {
        [modifidedPhones addObject:[self adjustPhoneNumber:p]];
    }
    [[TNetworking sharedInstance] getRate:modifidedPhones completion:^(NSDictionary *data, NSString *errorStr, NSError *error) {
        
        if (error) {
            [self showErrorMessage:[error localizedDescription]];
            return;
        }
        
        if (errorStr) {
            [self showErrorMessage:errorStr];
            return;
        }
        
        NSArray *arr = [data valueForKey:@"rates"];
        for (int i=0; i<arr.count; i++) {
            [rates addObject:[arr valueForKey:modifidedPhones[i]]];
        }
        [self.tableView reloadData];
    }];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.cachedAvatarImageViewSize = self.avatarImg.frame;
}

#pragma mark - Private methods

- (NSString *)adjustPhoneNumber:(NSString *)p
{
    NSString *phoneNumber;
    NSString *pn = [[p componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    if ([pn hasPrefix:@"+"] || [pn hasPrefix:@"00"] || [pn hasPrefix:@"011"]) {
        phoneNumber = pn;
    } else if ([pn hasPrefix:@"0"]) {
        phoneNumber = [pn substringFromIndex:1];
        phoneNumber = [NSString stringWithFormat:@"%@%@", self.appDelegate.telasco.countryCode, phoneNumber];
    } else {
        phoneNumber = pn;
    }
    return phoneNumber;
}

- (void)configCoverImage
{
    self.coverImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cover.png"]];
    self.coverImg.contentMode = UIViewContentModeScaleAspectFill;
    self.cachedCoverImageViewSize = CGRectMake(0, 0, self.view.frame.size.width, 80);
    [self.tableView addSubview:self.coverImg];
    [self.tableView sendSubviewToBack:self.coverImg];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 130)];
}

- (void)setupInfo
{
    self.nameLbl.text = self.person.compositeName;
    self.avatarImg.image = (self.person.thumbnail) ? self.person.thumbnail : [UIImage imageNamed:@"avatar"];
    self.avatarImg.layer.cornerRadius = 48;
    self.avatarImg.layer.borderWidth = 1.5;
    self.avatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImg.clipsToBounds = YES;
    self.avatarOriginalImg = self.avatarImg;
    [self.tableView reloadData];
    [self.view bringSubviewToFront:self.avatarImg];
}

#pragma mark - Actions

- (IBAction)dismissViewController:(id)sender
{
    [self.presentingPopinViewController dismissCurrentPopinControllerAnimated:YES completion:^{
    }];
}

- (IBAction)call:(UIButton *)sender
{
    [self callInNumber:modifidedPhones[sender.tag]];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  56;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return phones.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TContactDetailCell *cell = (TContactDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.phoneNumberLbl.text = phones[indexPath.row];
    cell.callBtn.tag = indexPath.row;
    
    if (rates.count > indexPath.row) {
        if (rates[indexPath.row] != [NSNull null]) {
            cell.indicator.hidden = YES;
            cell.callBtn.hidden = NO;
            cell.rateLbl.hidden = NO;
            cell.rateLbl.text = rates[indexPath.row];
        }
    } else {
        [cell.indicator startAnimating];
        cell.indicator.hidden = NO;
        cell.callBtn.hidden = YES;
        cell.rateLbl.hidden = YES;
    }
    
//    RHPerson *person = [self.person.phoneNumbers. objectAtIndex:indexPath.row];
//    cell.nameLbl.text = person.compositeName;
//    cell.avatarImg.image = (person.thumbnail) ? person.thumbnail : [UIImage imageNamed:@"avatar"];
    [cell.callBtn addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = -scrollView.contentOffset.y;
    [self adjustCoverImage:y];
}

- (void)adjustCoverImage:(CGFloat)y
{
    if (y > 0) {
        self.coverImg.frame = CGRectMake(0, self.cachedCoverImageViewSize.origin.y-y, self.cachedCoverImageViewSize.size.width+y, self.cachedCoverImageViewSize.size.height+ ( 1.5 * y));
        self.avatarImg.frame = CGRectMake(0, self.cachedAvatarImageViewSize.origin.y + (y/2), self.avatarImg.frame.size.width, self.avatarImg.frame.size.height);

        self.coverImg.center = CGPointMake(self.view.center.x, self.coverImg.center.y);
        self.avatarImg.center = CGPointMake(self.view.center.x, self.avatarImg.center.y);
    } else {
        self.avatarImg.frame = CGRectMake(0, self.cachedAvatarImageViewSize.origin.y+y, self.avatarImg.frame.size.width, self.avatarImg.frame.size.height);
        self.avatarImg.center = CGPointMake(self.view.center.x, self.avatarImg.center.y);
        [self.avatarImg setAlpha:1 -(((-1) * y)/30)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
