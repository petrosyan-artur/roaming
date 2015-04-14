//
//  TCountryListViewController.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/3/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TCountryListViewController.h"
#import "TCountryListCell.h"
#import "TList.h"

@interface TCountryListViewController ()
{
    NSMutableArray *items;
    NSArray *countries;
    NSArray *codes;
    NSArray *searchResults;
}
@end

@implementation TCountryListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    items = [NSMutableArray new];
    searchResults = [NSArray new];
    self.navigationController.view.backgroundColor = [UIColor lightGrayColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.searchDisplayController.tap.edgesForExtendedLayout = UIRectEdgeNone;
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getCountries];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    self.searchDisplayController.searchBar.frame = CGRectMake(7, 0, self.view.frame.size.width+1, self.searchDisplayController.searchBar.frame.size.height+1);
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([self.searchDisplayController.searchResultsTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.searchDisplayController.searchResultsTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.searchDisplayController.searchResultsTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.searchDisplayController.searchResultsTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (void)resizeSeachBarBackground
{
    for (UIView *view in self.searchDisplayController.searchBar.subviews)
    {
        if ([view respondsToSelector:@selector(subviews)])
        {
            for (UIView *view2 in view.subviews)
            {
                if ([view2 isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
                {
                    id UISearchBarBackground = view2;
                    
                    if ([UISearchBarBackground respondsToSelector:@selector(frame)])
                    {
                        [UISearchBarBackground setFrame:CGRectMake(0, -20, CGRectGetWidth([UIScreen mainScreen].bounds), 64.0)];
                        break;
                    }
                }
            }
        }
    }
}

//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
////    if (!self.navigationController.navigationBarHidden)
////        [self.navigationController setNavigationBarHidden:true animated:false];
//    
//    [self resizeSeachBarBackground];
// 
//}
#pragma mark - Private methods

- (void)getCountries
{
    countries = @[@"Afghanistan",@"Albania",@"Algeria",@"American Samoa",@"Andorra",@"Angola",@"Anguilla",@"Antarctica",@"Antigua and Barbuda",@"Argentina",@"Armenia",@"Aruba",@"Australia",@"Austria",@"Azerbaijan",@"Bahamas",@"Bahrain",@"Bangladesh",@"Barbados",@"Belarus",@"Belgium",@"Belize",@"Benin",@"Bermuda",@"Bhutan",@"Bolivia",@"Bosnia and Herzegovina",@"Botswana",@"Brazil",@"British Virgin Islands",@"Brunei",@"Bulgaria",@"Burkina Faso",@"Burma (Myanmar)",@"Burundi",@"Cambodia",@"Cameroon",@"Canada",@"Cape Verde",@"Cayman Islands",@"Central African Republic",@"Chad",@"Chile",@"China",@"Christmas Island",@"Cocos (Keeling) Islands",@"Colombia",@"Comoros",@"Cook Islands",@"Costa Rica",@"Croatia",@"Cuba",@"Cyprus",@"Czech Republic",@"Democratic Republic of the Congo",@"Denmark",@"Djibouti",@"Dominica",@"Dominican Republic",@"Ecuador",@"Egypt",@"El Salvador",@"Equatorial Guinea",@"Eritrea",@"Estonia",@"Ethiopia",@"Falkland Islands",@"Faroe Islands",@"Fiji",@"Finland",@"France",@"French Polynesia",@"Gabon",@"Gambia",@"Gaza Strip",@"Georgia",@"Germany",@"Ghana",@"Gibraltar",@"Greece",@"Greenland",@"Grenada",@"Guam",@"Guatemala",@"Guinea",@"Guinea-Bissau",@"Guyana",@"Haiti",@"Holy See (Vatican City)",@"Honduras",@"Hong Kong",@"Hungary",@"Iceland",@"India",@"Indonesia",@"Iran",@"Iraq",@"Ireland",@"Isle of Man",@"Israel",@"Italy",@"Ivory Coast",@"Jamaica",@"Japan",@"Jordan",@"Kazakhstan",@"Kenya",@"Kiribati",@"Kosovo",@"Kuwait",@"Kyrgyzstan",@"Laos",@"Latvia",@"Lebanon",@"Lesotho",@"Liberia",@"Libya",@"Liechtenstein",@"Lithuania",@"Luxembourg",@"Macau",@"Macedonia",@"Madagascar",@"Malawi",@"Malaysia",@"Maldives",@"Mali",@"Malta",@"Marshall Islands",@"Mauritania",@"Mauritius",@"Mayotte",@"Mexico",@"Micronesia",@"Moldova",@"Monaco",@"Mongolia",@"Montenegro",@"Montserrat",@"Morocco",@"Mozambique",@"Namibia",@"Nauru",@"Nepal",@"Netherlands",@"Netherlands Antilles",@"New Caledonia",@"New Zealand",@"Nicaragua",@"Niger",@"Nigeria",@"Niue",@"Norfolk Island",@"North Korea",@"Northern Mariana Islands",@"Norway",@"Oman",@"Pakistan",@"Palau",@"Panama",@"Papua New Guinea",@"Paraguay",@"Peru",@"Philippines",@"Pitcairn Islands",@"Poland",@"Portugal",@"Puerto Rico",@"Qatar",@"Republic of the Congo",@"Romania",@"Russia",@"Rwanda",@"Saint Barthelemy",@"Saint Helena",@"Saint Kitts and Nevis",@"Saint Lucia",@"Saint Martin",@"Saint Pierre and Miquelon",@"Saint Vincent and the Grenadines",@"Samoa",@"San Marino",@"Sao Tome and Principe",@"Saudi Arabia",@"Senegal",@"Serbia",@"Seychelles",@"Sierra Leone",@"Singapore",@"Slovakia",@"Slovenia",@"Solomon Islands",@"Somalia",@"South Africa",@"South Korea",@"Spain",@"Sri Lanka",@"Sudan",@"Suriname",@"Swaziland",@"Sweden",@"Switzerland",@"Syria",@"Taiwan",@"Tajikistan",@"Tanzania",@"Thailand",@"Timor-Leste",@"Togo",@"Tokelau",@"Tonga",@"Trinidad and Tobago",@"Tunisia",@"Turkey",@"Turkmenistan",@"Turks and Caicos Islands",@"Tuvalu",@"Uganda",@"Ukraine",@"United Arab Emirates",@"United Kingdom",@"United States",@"Uruguay",@"US Virgin Islands",@"Uzbekistan",@"Vanuatu",@"Venezuela",@"Vietnam",@"Wallis and Futuna",@"West Bank",@"Yemen",@"Zambia",@"Zimbabwe"];
     codes = @[@"93",@"355",@"213",@"1684",@"376",@"244",@"1264",@"672",@"1268",@"54",@"374",@"297",@"61",@"43",@"994",@"1242",@"973",@"880",@"1246",@"375",@"32",@"501",@"229",@"1441",@"975",@"591",@"387",@"267",@"55",@"1284",@"673",@"359",@"226",@"95",@"257",@"855",@"237",@"1",@"238",@"1345",@"236",@"235",@"56",@"86",@"61",@"61",@"57",@"269",@"682",@"506",@"385",@"53",@"357",@"420",@"243",@"45",@"253",@"1767",@"1809",@"593",@"20",@"503",@"240",@"291",@"372",@"251",@"500",@"298",@"679",@"358",@"33",@"689",@"241",@"220",@"970",@"995",@"49",@"233",@"350",@"30",@"299",@"1473",@"1671",@"502",@"224",@"245",@"592",@"509",@"39",@"504",@"852",@"36",@"354",@"91",@"62",@"98",@"964",@"353",@"44",@"972",@"39",@"225",@"1876",@"81",@"962",@"7",@"254",@"686",@"381",@"965",@"996",@"856",@"371",@"961",@"266",@"231",@"218",@"423",@"370",@"352",@"853",@"389",@"261",@"265",@"60",@"960",@"223",@"356",@"692",@"222",@"230",@"262",@"52",@"691",@"373",@"377",@"976",@"382",@"1664",@"212",@"258",@"264",@"674",@"977",@"31",@"599",@"687",@"64",@"505",@"227",@"234",@"683",@"672",@"850",@"1670",@"47",@"968",@"92",@"680",@"507",@"675",@"595",@"51",@"63",@"870",@"48",@"351",@"1",@"974",@"242",@"40",@"7",@"250",@"590",@"290",@"1869",@"1758",@"1599",@"508",@"1784",@"685",@"378",@"239",@"966",@"221",@"381",@"248",@"232",@"65",@"421",@"386",@"677",@"252",@"27",@"82",@"34",@"94",@"249",@"597",@"268",@"46",@"41",@"963",@"886",@"992",@"255",@"66",@"670",@"228",@"690",@"676",@"1868",@"216",@"90",@"993",@"1649",@"688",@"256",@"380",@"971",@"44",@"1",@"598",@"1340",@"998",@"678",@"58",@"84",@"681",@"970",@"967",@"260",@"263"];

    for (int i = 0; i < countries.count; i++) {
        
        TList *item = [TList new];
        item.isChecked = NO;
        item.countryName = countries[i];
        item.countryCode = codes[i];
        [items addObject:item];
    }
    [self.tableView reloadData];
}

- (void)chooseItemAtIndex:(int)index
{
    TList *item;

    if (self.searchDisplayController.active) {
        item = [searchResults objectAtIndex:index];
    } else {
        item = [items objectAtIndex:index];
    }
    AppDelegate *appDelegate = [AppDelegate sharedInstance];
    appDelegate.telasco.isNewChanges = YES;
    appDelegate.telasco.ID = item.ID;
    appDelegate.telasco.country = item.countryName;
    appDelegate.telasco.countryCode = item.countryCode;
    appDelegate.telasco.flagUrl = item.flagUrl;

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView's delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
        
    } else {
        return items.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Cell";
    TCountryListCell *cell = (TCountryListCell *)[self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TCountryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    TList *item;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        item = [searchResults objectAtIndex:indexPath.row];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    } else {
        item = items[indexPath.row];
    }
    [cell initWithName:item.countryName flagImgName:@"1.png"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self chooseItemAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"countryName contains[c] %@", searchText];
    searchResults = [items filteredArrayUsingPredicate:resultPredicate];
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

@end
