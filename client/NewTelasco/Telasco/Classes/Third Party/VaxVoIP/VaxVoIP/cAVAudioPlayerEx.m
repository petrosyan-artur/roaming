//
//  cAVAudioPlayerEx.m
//  VaxPhone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import "cAVAudioPlayerEx.h"
#import "cVaxGeneral.h"

@implementation cAVAudioPlayerEx

- (id) init;
{		
    mTimer = NULL;
    mPlayerWave = NULL;
    
    mActionPlayDone = NULL;
    mTargetPlayDone = NULL;
    
    mTargetPlayTick = NULL;
    mActionPlayTick = NULL;
    
    self = [super init];
	return self;
}

- (void) dealloc;
{	
    [self PlayUnload];
    [super dealloc];
}

- (void) Play :(int) nLoopCount;
{
    mPlayerWave.delegate = self; 
	mPlayerWave.numberOfLoops = nLoopCount;
    mPlayerWave.volume = 1.0;

    [mPlayerWave play];
}

- (void) Stop;
{
    [mPlayerWave stop];
}

- (void) Pause;
{
    [mPlayerWave pause];
}

- (void) PlayUnload;
{
    if(mPlayerWave)
    {
        [self Stop];
        [mPlayerWave release];
        mPlayerWave = NULL;
    }
    
    if(mTimer)
    {
        [mTimer invalidate];
        [mTimer release];
        mTimer = NULL;
    }
}

- (void) OnTimerTick :(NSTimer*) pObjTimer
{
    if(mTargetPlayTick != NULL)
        [mTargetPlayTick performSelector: mActionPlayTick withObject: self afterDelay: 0.0];
}

- (Boolean) IsPlaying;
{
    if(mPlayerWave == NULL)
        return false;
    
    return mPlayerWave.playing;
}

- (void) PlayStart :(int) nLoopCount;
{
    if(mPlayerWave == NULL)
        return;
    
    [self Play: nLoopCount];
    
    if(mTimer)
    {
        [mTimer invalidate];
        [mTimer release];
        mTimer = NULL;
    }
    
    if(mTargetPlayTick != NULL)
    {
        mTimer = [[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(OnTimerTick:) userInfo:self repeats: true] retain];
    }
}

- (void) PlayStop;
{
    if(mPlayerWave == NULL)
        return;
    
    if(mTimer)
    {
        [mTimer invalidate];
        [mTimer release];
        mTimer = NULL;
    }
    
    [self Stop];
}


- (void) PlayPause;
{
    if(mPlayerWave == NULL)
        return;
    
    if(mTimer)
    {
        [mTimer invalidate];
        [mTimer release];
        mTimer = NULL;
    }
    
    [self Pause];
}

- (void) PlayLoadWithData :(NSData*) pFileData;
{
    [self PlayUnload];
    
	mPlayerWave = [[AVAudioPlayer alloc] initWithData: pFileData error:NULL];
}

- (void) PlayLoadWithFile :(NSString*) pFileName;
{
    [self PlayUnload];
    
     if(![cVaxGeneral IsFileExist: pFileName]) return;
    
	mPlayerWave = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath: pFileName] error:NULL];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully :(BOOL)flag
{
    [self PlayPause];
    
    if(mTargetPlayDone != NULL)
        [mTargetPlayDone performSelector: mActionPlayDone withObject: self afterDelay: 0.0];
}

- (NSTimeInterval) GetTotalPlayTime;
{
    if(mPlayerWave == NULL)
        return 0;
    
    return [mPlayerWave duration];
}

- (NSTimeInterval) GetCurrentTime;
{
    if(mPlayerWave == NULL)
        return 0;
    
    return [mPlayerWave currentTime];
}

- (void) PlayAtTime :(NSTimeInterval) nTime;
{
    if(mPlayerWave == NULL)
        return;
    
    mPlayerWave.currentTime = nTime;
}

- (void) SetPlayDoneDelegate :(id) TargetOBJ :(SEL) ActionDONE;
{
    mTargetPlayDone = TargetOBJ;
    mActionPlayDone = ActionDONE;
}

- (void) SetPlayTickDelegate :(id) TargetOBJ :(SEL) ActionTICK;
{
    mTargetPlayTick = TargetOBJ;
    mActionPlayTick = ActionTICK;
}


@end
