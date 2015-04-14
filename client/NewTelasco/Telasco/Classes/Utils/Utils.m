//
//  Utils.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/2/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "Utils.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "cVaxSIPUserAgentEx.h"

@implementation Utils

+ (BOOL)isConnectedToInternet
{
    AppDelegate *aDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return aDelegate.isNetworkReachable;
}

+ (void)raundedButton:(UIButton *)btn
{
    btn.layer.cornerRadius = btn.bounds.size.width/2.0;
}

+ (void)saveToUserDefaults:(NSString *)key value:(id)valueString
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:valueString forKey:key];
        [standardUserDefaults synchronize];
    }
}

+ (id)readFromUserDefaults:(NSString *)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        return [standardUserDefaults objectForKey:key];
    }
    
    return nil;
}

+ (void)openLindedState:(UIStoryboard *)sb
{
    UINavigationController *vc = [sb instantiateViewControllerWithIdentifier:@"LNInitialSlideViewController"];
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:vc];
}

+ (NSString *)getDateStringFromDate:(NSDate *)date
{
//    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm"];
    
    NSDateFormatter *displayingFormatter = [NSDateFormatter new];
    [displayingFormatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm"];
    NSString *display = [displayingFormatter stringFromDate:date];
    
//    NSString *dateString = [dateFormatter stringFromDate:date];
//    return dateString;
     return display;
}

+ (NSDate *)getDateFromDateString:(NSString *)dateString
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"EEE, dd MMM YYYY HH:mm:ss VVVV"];

//    [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (void)showAlert:(NSString *)messageString
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:messageString
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (void)showAlert:(NSString *)titleString message:(NSString *)messageString
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleString
                                                    message:messageString
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (void)showAlertWithDelegate:(id)delegate message:(NSString *)messageString tag:(int)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:messageString
                                                   delegate:delegate
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    alert.tag = tag;
    [alert show];
}

+ (void)showAlertWithDelegate:(id)delegate title:(NSString *)title message:(NSString *)messageString cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle tag:(int)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:messageString
                                                   delegate:delegate
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitle, nil];
    alert.tag = tag;
    [alert show];
}

+ (CGSize)calculateTextSize:(NSString *)str textFont:(UIFont*)font maxWidth:(float)width
{
    CGSize textSize = [str sizeWithFont:font constrainedToSize:CGSizeMake(width, 1000) lineBreakMode: NSLineBreakByWordWrapping];
    return textSize;
}

+ (CGSize)getSizeOfLabelForGivenText:(NSString*)text Font:(UIFont*)fontForLabel Size:  (CGSize) constraintSize{
    CGRect labelRect = [text boundingRectWithSize:constraintSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:fontForLabel} context:nil];
    return (labelRect.size);
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (Boolean)onlineAccount
{
    //    if(![self CheckSettings])
    //        return false;
    AppDelegate *aDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if(![[cVaxSIPUserAgentEx GetOBJ] InitVaxVoIP:[NSString stringWithFormat:@"%@%@", aDelegate.telasco.countryCode, aDelegate.telasco.phoneNumber]:@"pDisplayName" :[NSString stringWithFormat:@"%@%@", aDelegate.telasco.countryCode, aDelegate.telasco.phoneNumber] :aDelegate.telasco.password : aDelegate.telasco.host : aDelegate.telasco.host : [aDelegate.telasco.port intValue]])
        
        return false;
    
    if(![[cVaxSIPUserAgentEx GetOBJ] VaxOpenLines])
        return false;
    
//    if(![[cVaxSIPUserAgentEx GetOBJ] RegisterToProxySIP])
//    {
//        [[cVaxSIPUserAgentEx GetOBJ] ErrorMessage];
//        return false;
//    }
    
    [[cVaxSIPUserAgentEx GetOBJ] EnableKeepAlive: 10];
    
    return TRUE;
}

+ (void)savaRecentContacts:(NSDate *)startDate endDate:(NSDate *)endDate phone:(NSString *)phone
{
    if (!startDate) {
        startDate = endDate;
    }

    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components: (NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit )
                                                        fromDate:startDate
                                                          toDate:[NSDate date]
                                                         options:0];
    
    NSString *d = [NSString stringWithFormat:@"%ld", [components day]];
    NSString *h = [NSString stringWithFormat:@"%ld", [components hour]];
    NSString *m = [NSString stringWithFormat:@"%ld", [components minute]];
    NSString *s = [NSString stringWithFormat:@"%ld", ([components second] == 0) ? [components second] : [components second]+1];

    NSString *duration = @"";
    if (d.length == 1 && ![d isEqualToString:@"0"]) {
        duration = [NSString stringWithFormat:@"%@ day ", d];
    }
    
    duration = [NSString stringWithFormat:@"%@%@:%@:%@", duration,
                                                                 (h.length == 1) ? [NSString stringWithFormat:@"0%@", h] : h,
                                                                 (m.length == 1) ? [NSString stringWithFormat:@"0%@", m] : m,
                                                                 (s.length == 1) ? [NSString stringWithFormat:@"0%@", s] : s];
    NSLog(@"duration %@", duration);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    NSString *dateInStringFormated = [dateFormatter stringFromDate:startDate];
    NSLog(@"%@", dateInStringFormated);

    
    // create recent item
    NSDictionary *dic = @{@"phone": phone,
                          @"duration" : duration,
                          @"startDate" : dateInStringFormated};
    
    // save item
    NSMutableArray *arr = [(NSMutableArray *)[Utils readFromUserDefaults:kRecentCalls] mutableCopy];
    if (!arr) {
        arr = [NSMutableArray new];
    }
    
    [arr insertObject:dic atIndex:0];
    [Utils saveToUserDefaults:kRecentCalls value:arr];
}

+ (void)removeRecentCallAtIndex:(int)index
{
    NSMutableArray *arr = [(NSMutableArray *)[Utils readFromUserDefaults:kRecentCalls] mutableCopy];
    if (arr.count >= index) {
        [arr removeObjectAtIndex:index];
        [Utils saveToUserDefaults:kRecentCalls value:arr];
    }
}

+ (NSString *)removeUnnecessaryStringFromPhoneNumber:(NSString *)str
{
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@" )(-"];
    str = [[str componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString:@""];

    return str;
}

+ (BOOL)isCorrectNumberFormat:(NSString *)str
{
    if (str.length < 8) {
        return NO;
    }
    
    NSString *n = str;
    
    if ([str hasPrefix:@"+"] || [str hasPrefix:@"00"] || [str hasPrefix:@"011"]) {
        NSString *pn = [Utils removeUnnecessaryStringFromPhoneNumber:n];
        
        NSString *p;
        if ([str hasPrefix:@"+"]) {
            p = [pn substringFromIndex:1];
        } else {
            p = pn;
        }

        NSCharacterSet *numericOnly = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:p];
        if ([numericOnly isSupersetOfSet:stringSet]) {
            NSLog(@"String has only numbers");
            return YES;
        }
        return NO;
    }
    return NO;
}

+ (BOOL)isValidNumberFormat:(NSString *)str
{
    if ([Utils isCorrectNumberFormat:str]) {
        return  YES;
    } else {  // 099 77887777  // Without prefix
       
        NSString *pn = [Utils removeUnnecessaryStringFromPhoneNumber:str];
        NSString *p;
        if ([str hasPrefix:@"+"]) {
            p = [pn substringFromIndex:1];
        } else {
            p = pn;
        }
        
        NSCharacterSet *numericOnly = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:p];
        if ([numericOnly isSupersetOfSet:stringSet]) {
            NSLog(@"String has only numbers");
            return YES;
        }
        return NO;
    }
    return NO;
}

#pragma mark - Cookies

+ (void)loadCookies
{
    NSData *cookieData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ApplicationCookie"];
    NSLog(@"Load cookies %@", cookieData);

    if ([cookieData length] > 0) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookieData];
        for (NSHTTPCookie *cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
}

+ (void)saveCookies
{
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSLog(@"Save cookies %@", cookiesData);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey: @"ApplicationCookie"];
    [defaults synchronize];
}

+ (NSArray *)removeObjectFromArray:(NSArray *)array withIndex:(int)index
{
    NSMutableArray *modifyableArray = [[NSMutableArray alloc] initWithArray:array];
    [modifyableArray removeObjectAtIndex:index];
    return [[NSArray alloc] initWithArray:modifyableArray];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
