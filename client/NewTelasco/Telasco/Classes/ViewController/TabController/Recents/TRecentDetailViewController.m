//
//  TRecentDetailViewController.m
//  Telasco
//
//  Created by Janna Hakobyan on 4/1/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TRecentDetailViewController.h"
#import "TRecentDetailCell.h"

#define kRecentItemHeight   20
#define kRecentRowSpace     10
#define kContactsRowSpace   15

@interface TRecentDetailViewController ()
{
    UIView *recentView;
    UIView *contactsView;
}
@end

@implementation TRecentDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kInfo;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Private methods

- (UIView *)createRecentView
{
    if (!recentView) {
        
        int padding = 15;
        int durationX = 135;
        int Y = padding;
        
        recentView = [[UIView alloc] init];
       
        UILabel *callHistory = [[UILabel alloc] initWithFrame:CGRectMake(padding, Y, 120, kRecentItemHeight)];
        callHistory.text = kCallHistory;
        callHistory.font = [UIFont fontWithName:PNFontBold size:14];
        [recentView addSubview:callHistory];
        
        Y += (kRecentRowSpace + kRecentItemHeight);

        
        for (int i=0; i<self.recentCall.calls.count; i++) {
            TCall *c = self.recentCall.calls[i];
            
            UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(padding, Y, 120, kRecentItemHeight)];
            dateLbl.text = c.date;
            dateLbl.textAlignment = NSTextAlignmentLeft;
            dateLbl.font = [UIFont fontWithName:PNFontReg size:13];
            [recentView addSubview:dateLbl];
            
            UILabel *durationLbl = [[UILabel alloc] initWithFrame:CGRectMake(durationX, Y, 80, kRecentItemHeight)];
            durationLbl.text = c.duration;
            durationLbl.textAlignment = NSTextAlignmentRight;
            durationLbl.font = [UIFont fontWithName:PNFontReg size:13];
            [recentView addSubview:durationLbl];

            Y += (kRecentRowSpace + kRecentItemHeight);
        }
    }
    return recentView;
}

- (int)getRecentViewHeight
{
    if (!self.recentCall) {
        return 0;
    } else {
        return ((self.recentCall.calls.count+1) * (kRecentItemHeight + kRecentRowSpace)) + (4*kRecentRowSpace);
    }
}

- (UIView *)createContactsView
{
    if (!contactsView) {
        
        int padding = 15;
        int Y = padding;
        
        contactsView = [[UIView alloc] init];
        contactsView.userInteractionEnabled = YES;
        contactsView.frame = CGRectMake(0, 0, self.view.frame.size.width, [self getContactsViewHeight]);
        for (int i=0; i<self.recentCall.phoneNumbers.count; i++) {

            UILabel *numberLbl = [[UILabel alloc] initWithFrame:CGRectMake(padding, Y, 200, kRecentItemHeight)];
            numberLbl.text = self.recentCall.phoneNumbers[i];
            numberLbl.textAlignment = NSTextAlignmentLeft;
            numberLbl.font = [UIFont fontWithName:PNFontReg size:16];
            [contactsView addSubview:numberLbl];
            
            if ([Utils isValidNumberFormat:self.recentCall.phoneNumbers[i]]) {
                UIButton *callBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-kContactsRowSpace-40, Y, 40, kRecentItemHeight)];
                callBtn.tag = i;
                callBtn.backgroundColor = [UIColor lightGrayColor];
                callBtn.tintColor = [UIColor blackColor];
                [callBtn setTitle:@"Call" forState:UIControlStateNormal];
                [callBtn setTitle:@"Call" forState:UIControlStateHighlighted];
                [callBtn addTarget:self action:@selector(callInNumber:) forControlEvents:UIControlEventTouchUpInside];
                [contactsView addSubview:callBtn];
            }
            Y += (kContactsRowSpace + kRecentItemHeight);
            
        }
    }
    return contactsView;
}

- (int)getContactsViewHeight
{
    if (!self.recentCall) {
        return 0;
    } else {
        return ((self.recentCall.phoneNumbers.count+1) * (kRecentItemHeight + kContactsRowSpace)) + kContactsRowSpace;
    }
}

#pragma mark - Actions

- (IBAction)callInNumber:(UIButton *)btn
{
    NSString *n = self.recentCall.phoneNumbers[btn.tag];
    [self callInNumber: [self adjustPhoneNumber:n] originPhoneNumber:n parent:self];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self getRecentViewHeight];
    } else {
        return [self getContactsViewHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? 80 : 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *identifier = [NSString stringWithFormat:@"Header%i", section];
    TRecentDetailCell *headerCell = (TRecentDetailCell *)[self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(headerCell == nil) {
        headerCell = [[TRecentDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [headerCell initHeaderWithName:self.recentCall.compositeName phoneNumber:self.recentCall.call.phoneNumber avatar:self.recentCall.thumbnail];
    
    return headerCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"Cell%i", indexPath.section];
    TRecentDetailCell *cell = (TRecentDetailCell *)[self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil) {
        cell = [[TRecentDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.section == 0) {
        [cell.contentView addSubview:[self createRecentView]];
    }
    if (indexPath.section == 1) {
        cell.userInteractionEnabled = YES;
        cell.contentView.userInteractionEnabled = YES;
        [cell.contentView addSubview:[self createContactsView]];
    }
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([tableView.indexPathsForVisibleRows indexOfObject:indexPath] == NSNotFound) {
//        NSLog(@"hide %ld", (long)indexPath.row);
//    }
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSArray *paths = [tableView indexPathsForVisibleRows];
//    NSIndexPath *lastRowIndex = paths[0];
//    NSLog(@"paths %ld", (long)lastRowIndex.row);
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
