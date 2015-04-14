//
//  TRecentCall.h
//  Telasco
//
//  Created by Janna Hakobyan on 3/26/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCall.h"

@interface TRecentCall : NSObject

@property (nonatomic, assign) int ringCount;
@property (nonatomic, strong) TCall *call;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSString *compositeName;
@property (nonatomic, strong) NSMutableArray *calls;
@property (nonatomic, strong) NSMutableArray *phoneNumbers;

- (void)updateData;

@end
