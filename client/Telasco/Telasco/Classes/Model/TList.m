//
//  TList.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/3/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TList.h"

@implementation TList

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (!self)
        return nil;
    
    if (dict[@"id"] != [NSNull null])
    {
        self.ID = dict[@"id"];
    }
    
    if (dict[@"name"] != [NSNull null])
    {
        self.countryName = dict[@"name"];
    }
    
    if (dict[@"code"] != [NSNull null])
    {
        self.countryCode =  [NSString stringWithFormat:@"+%@", dict[@"code"]];
    }
    
    if (dict[@"image_url"] != [NSNull null])
    {
        self.flagUrl = dict[@"image_url"];
//        self.flagUrl = [NSString stringWithFormat:@"%@%@/%@",PROFILE_PHOTO_URL, self.userId, self.profilePhotoName];
    }
    
    return self;
}


@end
