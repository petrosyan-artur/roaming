//
//  VaxBell.h
//  Softphone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cAVAudioPlayerEx.h"
#import "cVaxGeneral.h"

@interface VaxBell : NSObject
{
    cAVAudioPlayerEx* mRingTonePLAY;
    cAVAudioPlayerEx* mDialTonePLAY;
    cAVAudioPlayerEx* mBusyTonePLAY;
    
    NSMutableData* mDialToneDATA;
    NSMutableData* mRingToneDATA;
    NSMutableData* mBusyToneDATA;
    
    int m_nRingToneId;
}

- (id) init;
- (void) dealloc;

- (void) InitOBJ;
- (void) UnInitOBJ;

- (void) StartRingTone;
- (void) StopRingTone;

- (void) StartDialTone;
- (void) StopDialTone;

- (void) StartBusyTone;
- (void) StopBusyTone;

- (void) SetRingTone :(int) nRingToneId;
- (int) GetRingTone;

@end
