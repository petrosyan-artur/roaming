//
//  TContactsViewController.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/17/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TContactsViewController.h"
#import "TContactsCell.h"
#import <AddressBookUI/AddressBookUI.h>
#import "RHPerson.h"
#import "TContactsDetailViewController.h"
#import "TAccessManager.h"

@interface TContactsViewController ()

@property (nonatomic, strong) NSMutableArray *arrContactsData;
@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation TContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    addressBook = [RHAddressBook new];
    searchResults = [NSArray new];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.navigationController.view.backgroundColor = [UIColor lightGrayColor];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(addressBookChanged:) name:RHAddressBookExternalChangeNotification object:nil];
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[TAccessManager sharedInstance] enabledContactsAccess];
}

#pragma mark - Private methods

- (void)openContactDetailPage:(RHPerson *)person
{
    TContactsDetailViewController *vc = (TContactsDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"TContactsDetailViewController"];
    vc.person = person;
    [vc setPopinTransitionStyle:BKTPopinTransitionStyleCrossDissolve];
    [vc setPopinOptions:BKTPopinDefault];
    [vc setPopinAlignment:BKTPopinAlignementOptionCentered];
    [vc setPreferedPopinContentSize:CGSizeMake(self.appDelegate.window.frame.size.width, self.appDelegate.window.frame.size.height)];
    [vc setPopinTransitionDirection:BKTPopinTransitionDirectionTop];
    [self.tabBarController presentPopinController:vc animated:YES completion:^{
        NSLog(@"Popin presented !");
    }];
}

#pragma mark - AddressBookChangedNotification

- (void)addressBookChanged:(NSNotification*)notification
{
    [self.tableView reloadData];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    } else {
        peoples = [[addressBook peopleOrderedByUsersPreference] mutableCopy];
        return [peoples count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TContactsCell *cell = (TContactsCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil) {
        cell = [[TContactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    RHPerson *person = (tableView == self.searchDisplayController.searchResultsTableView) ? [searchResults objectAtIndex:indexPath.row] : [peoples objectAtIndex:indexPath.row];
    cell.nameLbl.text = person.compositeName;
    cell.avatarImg.image = (person.thumbnail) ? person.thumbnail : [UIImage imageNamed:@"avatar"];
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RHPerson *person = (tableView == self.searchDisplayController.searchResultsTableView) ? [searchResults objectAtIndex:indexPath.row] : [peoples objectAtIndex:indexPath.row];
    [self openContactDetailPage:person];
    [self.searchDisplayController setActive:NO animated:YES];
}

#pragma mark - UISearchDisplayController

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"compositeName contains[c] %@", searchText];
    searchResults = [peoples filteredArrayUsingPredicate:resultPredicate];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    UISearchBar *searchBar = controller.searchBar;
    UIView *superView = searchBar.superview;
    if (![superView isKindOfClass:[UITableView class]]) {
        [searchBar removeFromSuperview];
        [self.tableView addSubview:searchBar];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
