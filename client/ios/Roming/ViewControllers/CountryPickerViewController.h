//
//  CountryPickerViewController.h
//  Roming
//
//  Created by Karen Ghandilyan on 8/23/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CountryObject;
@protocol CountryPickerViewControllerDelegate <NSObject>

-(void)userSelcetedCountry:(CountryObject *)countryObj;

@end
@interface CountryPickerViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITableView *countriesTabelView;
@property (nonatomic, strong) id<CountryPickerViewControllerDelegate> delegate;

@end
