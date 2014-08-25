//
//  CountryPickerViewController.m
//  Roming
//
//  Created by Karen Ghandilyan on 8/23/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import "CountryPickerViewController.h"
#import "CountryCodeProcessingService.h"
#import "CountryObject.h"

@interface CountryPickerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *countriesArray;

@end

@implementation CountryPickerViewController
@synthesize countriesArray = _countriesArray;
@synthesize countriesTabelView = _countriesTabelView;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CountryCodeProcessingService *service = [CountryCodeProcessingService sharedInstance];
    _countriesArray = [service getCountryCodes];
    [_countriesTabelView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"CountryCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    CountryObject *countryObj = _countriesArray[indexPath.row];
    cell.textLabel.text = countryObj.countryName;
    cell.detailTextLabel.text = countryObj.dialCode;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _countriesArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CountryObject *countryObj = _countriesArray[indexPath.row];
    if ([_delegate respondsToSelector:@selector(userSelcetedCountry:)]) {
        [_delegate userSelcetedCountry:countryObj];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
