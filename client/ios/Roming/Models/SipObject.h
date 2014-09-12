//
//  SipObject.h
//  Rouming
//
//  Created by Karen Ghandilyan on 9/11/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SipObject : NSObject

@property (nonatomic, strong) NSString *hostName;
@property (nonatomic, strong) NSString *port;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
