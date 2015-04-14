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
#import "TRecentDetailViewController.h"
#import "MGSwipeButton.h"

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
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.exclusiveTouch = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
    [self sortItems];
    [self reloadAnimation];
}

#pragma mark - Private methods

- (void)sortRecentArray
{
    NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"phone" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
    NSArray *sortedArray = [items sortedArrayUsingDescriptors:sortDescriptors];
  
    NSArray *groups1 = [items valueForKeyPath:@"@unionOfObjects.phone"];
    NSArray *groups = [groups1 valueForKeyPath:@"@distinctUnionOfObjects.self"];

    NSMutableArray *unique = [NSMutableArray array];
    
    for (id obj in groups1) {
        if (![unique containsObject:obj]) {
            [unique addObject:obj];
        }
    }
    

    
    NSLog(@"group %@", groups);
    for (NSString *groupId in unique) {
        
        NSMutableDictionary *entry = [NSMutableDictionary new];
        [entry setObject:groupId forKey:@"phone"];
        
        NSArray *groupPhones = [items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"phone = %@", groupId]];
        NSLog(@"groupPhones %@", groupPhones);
        
        TRecentCall *rc = [TRecentCall new];
        
        for (int i = 0; i < groupPhones.count; i++) {
            rc.call = [[TCall alloc]initWithDictionary:groupPhones[i]];
            [rc updateData];
        }
        [recentCalls addObject:rc];
    }
}

- (void)sortItems
{
    for (int i=0; i<recentCalls.count; i++) {
        TRecentCall *rc = (TRecentCall *)recentCalls[i];
    
        for (RHPerson *obj in peoples) {
            RHMultiValue *p = (RHMultiValue *)obj.phoneNumbers.values;
            NSMutableArray *phones = (NSMutableArray *)p;
            
            if ([phones containsObject:rc.call.phoneNumber]) { // find contact
                rc.compositeName = obj.compositeName;
                rc.thumbnail = obj.thumbnail;
                rc.phoneNumbers = phones;
                break;
            }
            
            for (NSString *phoneWithoutSpace in phones) {
                NSString *pn = [[phoneWithoutSpace componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
                if ([pn isEqualToString:rc.call.phoneNumber]) { // find contact
                    rc.compositeName = obj.compositeName;
                    rc.thumbnail = obj.thumbnail;
                    rc.phoneNumbers = phones;
                    break;
                }
            }
        }
    }
}

- (void)getData
{
    recentCalls = [NSMutableArray new];
    items = [Utils readFromUserDefaults:kRecentCalls];
    [self sortRecentArray];
}

- (void)removeItemWithPhoneNumber:(NSString *)pn
{
    NSMutableArray *tempArr = [items mutableCopy];
    
    for (int i=0; i<items.count; i++) {
        if ([[items[i] valueForKey:@"phone"] isEqualToString:pn]) {
            [tempArr removeObject:items[i]];
        }
    }
    [Utils saveToUserDefaults:kRecentCalls value:tempArr];
}

- (void)reloadAnimation
{
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    if (recentCalls.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (NSArray *)createRightButtons:(int)number
{
    NSMutableArray *result = [NSMutableArray array];
    NSString* titles[2] = {@"Delete"};
    UIColor * colors[2] = {[UIColor redColor], [UIColor lightGrayColor]};
    for (int i = 0; i < number; ++i)
    {
        MGSwipeButton *button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender) {
            NSLog(@"Convenience callback received (right).");
            BOOL autoHide = i != 0;
            return autoHide; //Don't autohide in delete button to improve delete expansion animation
        }];
        [result addObject:button];
    }
    return result;
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
    cell.contentView.exclusiveTouch = YES;

    TRecentCall *rc = recentCalls[indexPath.row];
    [cell initWithName:rc.compositeName phoneNumber:rc.call.phoneNumber avatar:rc.thumbnail ringCount:rc.ringCount date:rc.call.date];

    cell.delegate = self;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TRecentCall *rc = recentCalls[indexPath.row];
    TRecentDetailViewController *vc = (TRecentDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"TRecentDetailViewController"];
    vc.recentCall = rc;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
}

- (NSArray *)swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings
{
    if (direction == MGSwipeDirectionRightToLeft && index == 0) {
        expansionSettings.fillOnTrigger = YES;
        return [self createRightButtons:1];
    }
    return nil;
}

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    NSLog(@"Delegate: button tapped, %@ position, index %d, from Expansion: %@",
          direction == MGSwipeDirectionLeftToRight ? @"left" : @"right", (int)index, fromExpansion ? @"YES" : @"NO");
    if (direction == MGSwipeDirectionLeftToRight && index == 0) {
        return YES;
    }
    if (direction == MGSwipeDirectionRightToLeft && index == 0) {
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
        TRecentCall *rc = recentCalls[path.row];
        [self removeItemWithPhoneNumber:rc.call.phoneNumber];
        [recentCalls removeObjectAtIndex:path.row];
        [_tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped accessory button");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
