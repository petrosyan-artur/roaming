//
//  cAVAudioPlayerEx.h
//  VaxPhone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface cAVAudioPlayerEx : NSObject  <AVAudioPlayerDelegate>
{
    AVAudioPlayer* mPlayerWave;
    
    id mTargetPlayDone;
    SEL mActionPlayDone;
    
    id mTargetPlayTick;
    SEL mActionPlayTick;
    
    NSTimer* mTimer;
}

- (id) init;
- (void) dealloc;

- (void) SetPlayTickDelegate :(id) TargetOBJ :(SEL) ActionTICK;
- (void) SetPlayDoneDelegate :(id) TargetOBJ :(SEL) ActionDONE;

- (void) PlayLoadWithData :(NSData*) pFileData;
- (void) PlayLoadWithFile :(NSString*) pFileName;

- (void) PlayUnload;

- (void) PlayStart :(int) nLoopCount;
- (void) PlayStop;

- (Boolean) IsPlaying;
- (void) PlayPause;

- (NSTimeInterval) GetTotalPlayTime;
- (NSTimeInterval) GetCurrentTime;

- (void) PlayAtTime :(NSTimeInterval) nTime;

@end
