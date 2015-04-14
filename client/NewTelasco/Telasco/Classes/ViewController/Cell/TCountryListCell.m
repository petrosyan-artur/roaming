//
//  TCountryListCell.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/3/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TCountryListCell.h"

@implementation TCountryListCell

- (void)initWithName:(NSString *)name flagImgName:(NSString *)flagImgName
{
    self.countryName.text = name;
    self.flagImg.image = [UIImage imageNamed:flagImgName];
}

@end
