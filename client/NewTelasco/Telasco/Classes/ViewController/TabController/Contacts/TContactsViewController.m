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
{
    BOOL isSearchActive;
    NSMutableArray *validPhoneArr;
    NSMutableArray *invalidPhoneArr; // change or remove
}

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation TContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.view.backgroundColor = [UIColor lightGrayColor];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(addressBookChanged:) name:RHAddressBookExternalChangeNotification object:nil];
//    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[TAccessManager sharedInstance] enabledContactsAccess];
    [self createSearchView];
    [self addTapGestureOnTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupView];
    [self hideSearchView];
    NSLog(@"kMainCountryCode %@", [Utils readFromUserDefaults:kMainCountryCode]);
}

#pragma mark - Private methods

- (void)setupView
{
    addressBook = [RHAddressBook new];
    searchResults = [NSArray new];
    validPhoneArr = [NSMutableArray new];
    invalidPhoneArr = [NSMutableArray new];
    [self sortContacts];
}

- (void)sortContacts
{
    peoples = [[addressBook peopleOrderedByUsersPreference] mutableCopy];
    validPhoneArr = [NSMutableArray new];
    
    NSString *str1 = [NSString stringWithFormat:@"+%@", [Utils readFromUserDefaults:kMainCountryCode]];
    NSString *str2 = [NSString stringWithFormat:@"00%@", [Utils readFromUserDefaults:kMainCountryCode]];
    NSString *str3 = [NSString stringWithFormat:@"011%@", [Utils readFromUserDefaults:kMainCountryCode]];
    
    for (RHPerson *person in peoples) {
        RHMultiValue *p = (RHMultiValue *)person.phoneNumbers.values;
        NSMutableArray *phones = (NSMutableArray *)p;
        for (NSString *s in phones) {
            NSString *pn = [[s componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];

            if ([pn hasPrefix:str1] || [pn hasPrefix:str2] || [pn hasPrefix:str3]) {
                [validPhoneArr addObject:person];
            }
        }
    }
    [self.tableView reloadData];
}

- (void)addTapGestureOnTableView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    tap.delegate = self;
    [self.tableView addGestureRecognizer:tap];
}

- (void)openContactDetailPage:(RHPerson *)person
{
    TContactsDetailViewController *vc = (TContactsDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"TContactsDetailViewController"];
    vc.person = person;
    [vc setPopinTransitionStyle:BKTPopinTransitionStyleCrossDissolve];
    [vc setPopinOptions:BKTPopinDefault];
    [vc setPopinAlignment:BKTPopinAlignementOptionCentered];
    [vc setPreferedPopinContentSize:CGSizeMake(self.appDelegate.window.frame.size.width, self.appDelegate.window.frame.size.height)];
    [vc setPopinTransitionDirection:BKTPopinTransitionDirectionTop];
    
    if (isSearchActive) {
        [self hideSearchView];
    }
    [self.tabBarController presentPopinController:vc animated:YES completion:^{
        NSLog(@"Popin presented !");
    }];
}

- (void)createSearchView
{
    self.searchView = [[UIView alloc] initWithFrame:CGRectMake(0, -60, self.view.frame.size.width, 44)];
    self.searchView.backgroundColor = [UIColor colorWithRed:249/255.0f green:249/255.0f blue:249/255.0f alpha:1.0f];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.searchView.frame.size.height)];
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.tintColor = [UIColor redColor];
    self.searchBar.backgroundImage = [Utils imageWithColor:[UIColor colorWithRed:249/255.0f green:249/255.0f blue:249/255.0f alpha:1.0f]];

    [self.searchView addSubview:self.searchBar];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.searchView];
    
    self.searchView.hidden = YES;
}

- (void)showSearchView
{
    if (self.searchView.frame.origin.y == 0) {
        return;
    }
    self.searchGrayView.hidden = NO;
    [self.searchBar becomeFirstResponder];
    self.searchBar.showsCancelButton = YES;
    [self.searchBar setShowsCancelButton:YES animated:YES];
    isSearchActive = YES;
    
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.searchView.hidden = NO;
        self.searchView.frame  = CGRectMake(0, 0, self.searchView.frame.size.width, self.searchView.frame.size.height);
        
    } completion:^(BOOL finished) { }];
}

- (void)hideSearchView
{
    if (self.searchView.frame.origin.y == -60) {
        return;
    }

    self.searchGrayView.hidden = YES;
    isSearchActive = NO;
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.searchView.frame = CGRectMake(0, -60, self.searchView.frame.size.width, self.searchView.frame.size.height);
        [self.view endEditing:YES];
        [self.searchBar resignFirstResponder];
    } completion:^(BOOL finished) {
        self.searchView.hidden = YES;
        self.searchBar.text = @"";
        [self.tableView reloadData];
    }];
}

- (NSMutableArray *)getActiveArray
{
    return (self.segmentControl.selectedSegmentIndex == 0) ? validPhoneArr : peoples;
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
    if (isSearchActive) {
        return searchResults.count;
    } else {
        NSLog(@"%i", [[self getActiveArray] count]);
        return [[self getActiveArray] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TContactsCell *cell = (TContactsCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil) {
        cell = [[TContactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    RHPerson *person = (isSearchActive) ? [searchResults objectAtIndex:indexPath.row] : [[self getActiveArray] objectAtIndex:indexPath.row];
    cell.nameLbl.text = person.compositeName;
    cell.avatarImg.image = (person.thumbnail) ? person.thumbnail : [UIImage imageNamed:@"avatar"];
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RHPerson *person = (isSearchActive) ? [searchResults objectAtIndex:indexPath.row] : [[self getActiveArray] objectAtIndex:indexPath.row];
    [self openContactDetailPage:person];
}

#pragma mark - UISearchDisplayController

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSMutableArray *arr = [self getActiveArray];
    if (searchText.length == 0) {
        searchResults = arr;
        self.searchGrayView.hidden = NO;
    } else {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"compositeName contains[c] %@", searchText];
        searchResults = [arr filteredArrayUsingPredicate:resultPredicate];
        if (searchResults.count == 0) {
            self.searchGrayView.hidden = NO;
        } else {
            self.searchGrayView.hidden = YES;
        }
    }
    [self.tableView reloadData];
}

//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    [self filterContentForSearchText:searchString
//                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
//                                      objectAtIndex:[self.searchDisplayController.searchBar
//                                                     selectedScopeButtonIndex]]];
//    
//    return YES;
//}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

//- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
//{
//    UISearchBar *searchBar = controller.searchBar;
//    UIView *superView = searchBar.superview;
//    if (![superView isKindOfClass:[UITableView class]]) {
//        [searchBar removeFromSuperview];
//        [self.tableView addSubview:searchBar];
//    }
//}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0)
{
    return YES;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
   return YES;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText
{
    [self filterContentForSearchText:searchText scope:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self hideSearchView];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    dispatch_async(dispatch_get_main_queue(), ^{
        __block __weak void (^weakEnsureCancelButtonRemainsEnabled)(UIView *);
        void (^ensureCancelButtonRemainsEnabled)(UIView *);
        weakEnsureCancelButtonRemainsEnabled = ensureCancelButtonRemainsEnabled = ^(UIView *view) {
            for (UIView *subview in view.subviews) {
                if ([subview isKindOfClass:[UIControl class]]) {
                    [(UIControl *)subview setEnabled:YES];
                }
                weakEnsureCancelButtonRemainsEnabled(subview);
            }
        };
        
        ensureCancelButtonRemainsEnabled(searchBar);
    });
}

#pragma mark - UISegmentedControl

- (IBAction)segmentSwitch:(UISegmentedControl *)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [self.tableView reloadData];
    [UIView commitAnimations];
}

#pragma mark - Actions

- (IBAction)search:(id)sender
{
    [self showSearchView];
}

- (IBAction)hideSearch:(id)sender
{
    [self hideSearchView];
}

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!isSearchActive && scrollView.contentOffset.y < -15) {
        [self showSearchView];
    }
}

#pragma mark - UITapGestureRecognizer

- (void)handleGesture:(UITapGestureRecognizer*)gestureRecognizer
{
    if (isSearchActive && ![self.searchBar.text isEqualToString:@""]) {
        [self.view endEditing:YES];
        [self.searchBar resignFirstResponder];
    }
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.tableView]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
