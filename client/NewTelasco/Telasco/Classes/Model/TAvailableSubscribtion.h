//
//  TAvailableSubscribtion.h
//  Telasco
//
//  Created by Janna Hakobyan on 4/13/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAvailableSubscribtion : NSObject

@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *url;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
