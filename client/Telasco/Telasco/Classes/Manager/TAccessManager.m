//
//  TAccessManager.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/9/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TAccessManager.h"
#import <AVFoundation/AVAudioSession.h>
#import <AddressBookUI/AddressBookUI.h>

@implementation TAccessManager

+ (TAccessManager *)sharedInstance
{
    static TAccessManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TAccessManager alloc] init];
    });
    
    return sharedInstance;
}

- (void)enabledMicrophoneAccess
{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            NSLog(@"Permission granted");
        }
        else {
            NSLog(@"Permission denied");
            [Utils showAlert:@"Microphone Permission denied"];
        }
    }];
}

- (void)enabledContactsAccess
{
    ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
        if (!granted){
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:@"Contacts Permission denied" waitUntilDone:YES];
            return;
        }
       
        NSLog(@"Just authorized");
    });
}

- (void)showAlert:(NSString *)str
{
    [Utils showAlert:str];
}

//- (BOOL)isMicrophoneAccessEnabled
//{
//    if ([AVAudioSession sharedInstance].recordPermission == AVAudioSessionRecordPermissionGranted) {
//        return YES;
//    }
//    return NO;
//}

@end
