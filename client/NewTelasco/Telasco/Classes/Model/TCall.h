//
//  TCall.h
//  Telasco
//
//  Created by Janna Hakobyan on 3/26/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCall : NSObject

@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *date;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
