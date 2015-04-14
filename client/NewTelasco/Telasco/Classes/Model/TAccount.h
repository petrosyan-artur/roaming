//
//  TAccount.h
//  Telasco
//
//  Created by Janna Hakobyan on 4/13/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAccount : NSObject

@property (nonatomic, strong) NSNumber *activeDays;
@property (nonatomic, strong) NSNumber *bonusDays;
@property (unsafe_unretained) int availableSubscribtionCount;
@property (nonatomic, strong) NSMutableArray *availableSubscribtionArr;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
