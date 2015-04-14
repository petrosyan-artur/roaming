//
//  VaxBell.m
//  Softphone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import "VaxBell.h"

@implementation VaxBell

- (id) init;
{
    mDialToneDATA = [[NSMutableData new] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"phoneCalling" ofType:@"wav"]];
    
    mBusyToneDATA = [[NSMutableData new] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"phoneBusy" ofType:@"wav"]];
    
    m_nRingToneId = VAX_RING_TONE_ELEGANT;
    mRingToneDATA = NULL;

    mDialTonePLAY = NULL;
    mRingTonePLAY = NULL;
    mBusyTonePLAY = NULL;
    
    self = [super init];
	return self;
}

- (void) dealloc;
{	
    [self UnInitOBJ];
    [super dealloc];
    
    [mDialToneDATA release];
    [mBusyToneDATA release];
    
    if(mRingToneDATA)
    {
        [mRingToneDATA release];
        mRingToneDATA = NULL;
    }
}

- (void) InitOBJ;
{
    mDialTonePLAY = NULL;
    mRingTonePLAY = NULL;
    mBusyTonePLAY = NULL;
}

- (void) UnInitOBJ;
{
    if(mDialTonePLAY)
    {
        [mDialTonePLAY release];
        mDialTonePLAY = NULL;
    }
        
    if(mRingTonePLAY)
    {
        [mRingTonePLAY release];
        mRingTonePLAY = NULL;
    }
        
    if(mBusyTonePLAY)
    {
        [mBusyTonePLAY release];
        mBusyTonePLAY = NULL;
    }
}

- (void) LoadRingTone :(NSString*) pFileName;
{
    if(mRingToneDATA)
    {
        [mRingToneDATA release];
        mRingToneDATA = NULL;
    }
    
    mRingToneDATA = [[NSMutableData new] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pFileName ofType:@"mp3"]];
}

- (void) SetRingTone :(int) nRingToneId;
{
    m_nRingToneId = nRingToneId;
    
    if(nRingToneId == VAX_RING_TONE_1985_RING)
    {
        [self LoadRingTone: @"1985_Ring"];
    }
    else if(nRingToneId == VAX_RING_TONE_ELEGANT)
    {
        [self LoadRingTone: @"Elegant_Ring"];
    }
    else if(nRingToneId == VAX_RING_TONE_MAGICAL)
    {
        [self LoadRingTone: @"Magical_Ring"];
    }
    else if(nRingToneId == VAX_RING_TONE_OFFICE_I_PHONE)
    {
        [self LoadRingTone: @"Office_I_Phone_Ring"];
    }
    else if(nRingToneId == VAX_RING_TONE_OFFICE_PHONE)
    {
        [self LoadRingTone: @"Office_Phone_Ring"];
    }
    else
    {
        [self LoadRingTone: @"Elegant_Ring"];
    }
}

- (int) GetRingTone;
{
    return m_nRingToneId;
}


- (void) StartRingTone;
{
    if(mRingTonePLAY) return;
    
    mRingTonePLAY = [cAVAudioPlayerEx new];
    [mRingTonePLAY PlayLoadWithData: mRingToneDATA];
    [mRingTonePLAY PlayStart: -1];
}

- (void) StopRingTone;
{
	if(mRingTonePLAY)
    {
        [mRingTonePLAY release];
        mRingTonePLAY = NULL;
    }
}

- (void) StartDialTone;
{
    if(mDialTonePLAY) return;
    
    mDialTonePLAY = [cAVAudioPlayerEx new];
    [mDialTonePLAY PlayLoadWithData: mDialToneDATA];
    [mDialTonePLAY PlayStart: -1];
}

- (void) StopDialTone;
{
    if(mDialTonePLAY)
    {
        [mDialTonePLAY release];
        mDialTonePLAY = NULL;
    }
}

- (void) StartBusyTone;
{
    if(mBusyTonePLAY) return;
    
    mBusyTonePLAY = [cAVAudioPlayerEx new];
    [mBusyTonePLAY PlayLoadWithData: mBusyToneDATA];
    [mBusyTonePLAY PlayStart: -1];
}

- (void) StopBusyTone;
{
    if(mBusyTonePLAY)
    {
        [mBusyTonePLAY release];
        mBusyTonePLAY = NULL;
    }
}


@end
