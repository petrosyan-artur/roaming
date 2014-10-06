//
//  ContactsData.h
//  Rouming
//
//  Created by Karen Ghandilyan on 9/26/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsData : NSObject

@property (nonatomic, strong) NSString *firstNames;
@property (nonatomic, strong) NSString *lastNames;
@property (nonatomic, strong) NSString *phonenumber;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSArray *numbers;
@property (nonatomic, strong) NSArray *emails;



@end
