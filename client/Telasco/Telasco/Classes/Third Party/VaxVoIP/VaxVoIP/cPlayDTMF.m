//
//  cPlayDTMF.m
//  Softphone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import "cPlayDTMF.h"
#import "cAVAudioPlayerEx.h"
#import "cVaxSIPUserAgentEx.h"

@implementation cPlayDTMF

- (id) init;
{	
    mPlayerWave = [cAVAudioPlayerEx new];
     
    self = [super init];
	return self;
}

- (void) dealloc;
{	
    [mPlayerWave release];
    [super dealloc];
}

- (void) PlayStop;
{
    [mPlayerWave PlayStop];
}

- (void) PlayStart :(NSString*) pName :(int) nDigit;
{
    [self PlayStop];
    
    [mPlayerWave PlayLoadWithFile: [[NSBundle mainBundle] pathForResource: pName ofType: @"wav"]];
    
    [mPlayerWave SetPlayDoneDelegate: self: @selector(OnPlayWaveDone:)];
    [mPlayerWave PlayStart: 0];
}

- (void) OnPlayWaveDone :(cAVAudioPlayerEx*) pAudioPlayer;
{
    [self PlayStop];
}

- (void) PlayDTMF :(int) nDigit;
{
    switch(nDigit)
    {
        case 0:
            [self PlayStart: @"0": 0];
        break;
            
        case 1:
            [self PlayStart: @"1": 1];
        break;
        
        case 2:
            [self PlayStart: @"2": 2];
        break;
            
        case 3:
            [self PlayStart: @"3": 3];
            break;
            
        case 4:
            [self PlayStart: @"4": 4];
            break;
            
        case 5:
            [self PlayStart: @"5": 5];
            break;
            
        case 6:
            [self PlayStart: @"6": 6];
            break;
            
        case 7:
            [self PlayStart: @"7": 7];
            break;
            
        case 8:
            [self PlayStart: @"8": 8];
            break;
            
        case 9:
            [self PlayStart: @"9": 9];
            break;
            
        case 10:
            [self PlayStart: @"star": 10];
            break;
            
        case 11:
            [self PlayStart: @"Number": 11];
            break;

    }

}

@end
