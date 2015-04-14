//
//  TCountryListCell.h
//  Telasco
//
//  Created by Janna Hakobyan on 3/3/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCountryListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *flagImg;
@property (nonatomic, weak) IBOutlet UILabel *countryName;

- (void)initWithName:(NSString *)name flagImgName:(NSString *)flagImgName;

@end
