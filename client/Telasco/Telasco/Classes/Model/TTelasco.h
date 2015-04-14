//
//  TTelasco.h
//  Telasco
//
//  Created by Janna Hakobyan on 3/4/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTelasco : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *flagUrl;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *port;
@property (nonatomic, strong) NSString *username;
@property (nonatomic) BOOL isNewChanges;

@property (nonatomic, strong) NSNumber *nextTry;

- (void)initWithData:(NSDictionary *)dic;
- (BOOL)isLogined;
- (void)update;

//- (void)saveObject:(TTelasco *)object;
//- (TTelasco *)loadObject;

@end
