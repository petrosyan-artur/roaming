//
//  TRecentsViewController.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/25/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TRecentsViewController.h"
#import "TRecentCallCell.h"
#import "TRecentCall.h"

@interface TRecentsViewController ()
{
    NSMutableArray *items;
    RHAddressBook *addressBook;
    NSMutableArray *peoples;
    NSMutableArray *recentCalls;
}
@end

@implementation TRecentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    items = [NSMutableArray new];
    addressBook = [RHAddressBook new];
    recentCalls = [NSMutableArray new];
    peoples = [[addressBook peopleOrderedByUsersPreference] mutableCopy];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getData];
    [self sortItems];
}

#pragma mark - Private methods

- (void)sortItems
{
    NSMutableArray *nonNameRecentArr = [NSMutableArray new];
    
    for (RHPerson *obj in peoples) {
        RHMultiValue *p = (RHMultiValue *)obj.phoneNumbers.values;
        NSMutableArray *phones = (NSMutableArray *)p;
        NSLog(@"p - %@", phones);
        
        
        int count = 0;
        for (int i=0; i<items.count; i++) {
            for (int j=0; j<phones.count; j++) {

//                if ([phones containsObject:items[i]]) {
//                    count++;
//                }
                NSString *p1 = [[phones[j] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
                NSString *p2 = [[[items[i] valueForKey:@"phone"] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];

                if (p1.length > 0 && p2.length > 0 && [p1 isEqualToString:p2]) {
                    count++;
                }
            }
        
       
            TRecentCall *rc = [TRecentCall new];
            rc.ringCount = count;
          
            if (count != 0) {
                
                rc.thumbnail = obj.thumbnail;
                rc.compositeName = obj.compositeName;
                rc.call.duration = [items[i] valueForKey:@"duration"];
                rc.call.date = [items[i] valueForKey:@"startDate"];
//                rc.phoneNumbers = [items[i] valueForKey:@"phone"];
            } else {
                [rc.call initWithDictionary:items[i]];
                [rc.call initWithDictionary:items[i]];
                
            }
            [recentCalls addObject:rc];

        }
    }
    
    for (TRecentCall *r in recentCalls) {
        NSLog(@"name %@", r.compositeName);
        NSLog(@"phone %@", r.call.phoneNumber);
        NSLog(@"callCount %i", r.ringCount);
        NSLog(@"------");
    }
}

- (void)getData
{
    items = [Utils readFromUserDefaults:kRecentCalls];
    [self reloadAnimation];
}

- (void)reloadAnimation
{
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return recentCalls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TRecentCallCell *cell = (TRecentCallCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil) {
        cell = [[TRecentCallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    TRecentCall *rc = recentCalls[indexPath.row];
    [cell initWithName:rc.compositeName phoneNumber:rc.call.phoneNumber avatar:rc.thumbnail ringCount:rc.ringCount date:rc.call.date];
    
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
