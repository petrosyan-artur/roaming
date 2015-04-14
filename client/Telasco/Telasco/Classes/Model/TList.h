//
//  TList.h
//  Telasco
//
//  Created by Janna Hakobyan on 3/3/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TList : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *flagUrl;
@property (nonatomic, strong) NSString *countryName;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic) BOOL isChecked;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
