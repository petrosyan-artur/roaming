//
//  cAudioMedia.h
//  Softphone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define AUDIO_MEDIA_NONE                100
#define AUDIO_MEDIA_SPEAKER             101
#define AUDIO_MEDIA_HEADPHONE           102
#define AUDIO_MEDIA_RECEIVER_AND_MIC    103
#define AUDIO_MEDIA_BLUE_TOOTH          104

@interface cAudioMedia : NSObject 
{
   
}

+ (void) ActivateListener;
+ (void) SpeakerPhone :(Boolean) bEnable;

+ (void) VaxCaptureMedia;
+ (void) VaxReleaseMedia;

+ (void) SetActiveMedia :(int) nAudioMediaId;
+ (void) UpdateMedia;

+ (int) GetMediaRoute;
+ (Boolean) SetMediaRoute :(int) nAudioMediaId;


@end
