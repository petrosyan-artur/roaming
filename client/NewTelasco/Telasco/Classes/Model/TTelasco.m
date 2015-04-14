//
//  TTelasco.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/4/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TTelasco.h"

#define kTelasco @"Telasco"

@implementation TTelasco

//- (void)encodeWithCoder:(NSCoder *)encoder
//{
//    [encoder encodeObject:self.ID forKey:@"ID"];
//    [encoder encodeObject:self.country forKey:@"country"];
//    [encoder encodeObject:self.countryCode forKey:@"countryCode"];
//    [encoder encodeObject:self.flagUrl forKey:@"flagUrl"];
//    [encoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
//}
//
//#pragma mark - Public methods
//
//- (void)saveObject:(TTelasco *)object
//{
//    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:encodedObject forKey:kTelasco];
//    [defaults synchronize];
//}
//
//- (TTelasco *)loadObject
//{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSData *encodedObject = [defaults objectForKey:kTelasco];
//    TTelasco *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
//    return object;
//}

- (void)initWithData:(NSDictionary *)dic
{
    if ([[[dic valueForKey:@"data"] valueForKey:@"sip"] valueForKey:@"host"] != [NSNull null])
    {
        self.host = [[[dic valueForKey:@"data"] valueForKey:@"sip"] valueForKey:@"host"];
        [Utils saveToUserDefaults:kHost value:self.host];
    }
    
    if ([[[dic valueForKey:@"data"] valueForKey:@"sip"] valueForKey:@"password"] != [NSNull null])
    {
        self.password = [[[dic valueForKey:@"data"] valueForKey:@"sip"] valueForKey:@"password"];
        [Utils saveToUserDefaults:kPassword value:self.password];
    }
    
    if ([[[dic valueForKey:@"data"] valueForKey:@"sip"] valueForKey:@"port"] != [NSNull null])
    {
        self.port = [[[dic valueForKey:@"data"] valueForKey:@"sip"] valueForKey:@"port"];
        [Utils saveToUserDefaults:kPort value:self.port];
    }

    if ([[[dic valueForKey:@"data"] valueForKey:@"sip"] valueForKey:@"username"] != [NSNull null])
    {
        self.username = [[[dic valueForKey:@"data"] valueForKey:@"sip"] valueForKey:@"username"];
        [Utils saveToUserDefaults:kUserName value:self.username];
    }
    
    
    if (self.host.length > 0 && self.password.length > 0 && self.port.length > 0 && self.username.length > 0) {
        [Utils saveToUserDefaults:kCountry value:self.country];
        [Utils saveToUserDefaults:kCountryCode value:self.countryCode];
        [Utils saveToUserDefaults:kPhoneNumber value:self.phoneNumber];
        [Utils saveToUserDefaults:kLogined value:kYes];
    }
}

- (BOOL)isLogined
{
    if ([[Utils readFromUserDefaults:kLogined] isEqualToString:kYes]) {
        return YES;
    }
    return NO;
}

- (void)update
{
    self.host = [Utils readFromUserDefaults:kHost];
    self.password = [Utils readFromUserDefaults:kPassword];
    self.username = [Utils readFromUserDefaults:kUserName];
    self.port = [Utils readFromUserDefaults:kPort];
    self.phoneNumber = [Utils readFromUserDefaults:kPhoneNumber];
    self.countryCode = [Utils readFromUserDefaults:kCountryCode];
    self.country = [Utils readFromUserDefaults:kCountry];
}


@end
