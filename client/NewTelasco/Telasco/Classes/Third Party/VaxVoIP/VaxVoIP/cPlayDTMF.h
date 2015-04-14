//
//  cPlayDTMF.h
//  Softphone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class cAVAudioPlayerEx;

@interface cPlayDTMF : NSObject
{
    cAVAudioPlayerEx* mPlayerWave;
}

- (id) init;
- (void) dealloc;

- (void) PlayDTMF :(int) nDigit;

@end
