//
//  PhoneContact.h
//  iOSContacts
//
//  Created by James Roche on 24/05/2014.
//  Copyright (c) 2014 James Roche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneContact : NSObject
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;
@property (nonatomic, strong) NSString* businessName;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* phone;

typedef enum
{
    ContactFilterAll,
    ContactFilterPhone,
    ContactFilterEmail
} ContactFilter;

+(PhoneContact*)getFromRef:(id)ref;
+(NSArray*)contacts;
+(NSArray*)contactsWithFilter:(ContactFilter)filter;

@end