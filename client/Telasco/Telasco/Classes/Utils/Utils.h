//
//  Utils.h
//  Telasco
//
//  Created by Janna Hakobyan on 3/2/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Utils : NSObject

+ (BOOL)isConnectedToInternet;
+ (void)raundedButton:(UIButton *)btn;
+ (void)saveToUserDefaults:(NSString*)key value:(id)value;
+ (id)readFromUserDefaults:(NSString*)key;
+ (NSString *)getDateStringFromDate :(NSDate *)date;
+ (NSDate *)getDateFromDateString :(NSString *)dateString;
+ (void)showAlert:(NSString *)messageString;
+ (void)showAlert:(NSString *)titleString message:(NSString *)messageString;
+ (void)showAlertWithDelegate:(id)delegate message:(NSString *)messageString tag:(int)tag;
+ (void)showAlertWithDelegate:(id)delegate title:(NSString *)title message:(NSString *)messageString cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle tag:(int)tag;
+ (CGSize)calculateTextSize:(NSString *)str textFont:(UIFont*)font maxWidth:(float)width;
+ (CGSize)getSizeOfLabelForGivenText:(NSString *)text Font:(UIFont*)fontForLabel Size:(CGSize) constraintSize;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (Boolean)onlineAccount;
+ (void)savaRecentContacts:(NSDate *)startDate endDate:(NSDate *)endDate phone:(NSString *)phone;
+ (void)removeRecentCallAtIndex:(int)index;

@end
