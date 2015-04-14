//
//  cAudioMedia.m
//  Softphone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import "cAudioMedia.h"
#import "cVaxSIPUserAgentEx.h"
#import <AudioUnit/AudioUnit.h>
#include <AudioToolbox/AudioToolbox.h>
#include <AudioToolbox/AudioQueue.h>

static Boolean m_bVaxMediaCaptured = false;
static Boolean m_bMediaSpeakerPhone = false;
static Boolean m_bMediaDisablingSpeakerPhone = false;
static int m_nMediaStoredSpeakerPhoneId = -1;
static int m_nAudioSessionCategory = -1;

static void MyPropertyListener (void* inClientData, AudioSessionPropertyID inID, UInt32 inDataSize, const void* inData)
{
    //NSLog(@"MyPropertyListener\n");
    [cAudioMedia UpdateMedia];
}

@implementation cAudioMedia

+ (void) UpdateMedia;
{
    int nAudioMediaActiveDevice = [cAudioMedia GetMediaRoute];
    [cAudioMedia SetActiveMedia: nAudioMediaActiveDevice];
}

+ (void) ActivateListener;
{
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionAddPropertyListener (kAudioSessionProperty_AudioRouteChange, MyPropertyListener, (__bridge void *)(self));
    
    [cAudioMedia SetActiveMedia: AUDIO_MEDIA_RECEIVER_AND_MIC];
    [cAudioMedia UpdateMedia];
}

+ (void) SetActiveMedia :(int) nAudioMediaId;
{
    if(m_bVaxMediaCaptured)
    {
        if(m_nAudioSessionCategory != kAudioSessionCategory_PlayAndRecord)
        {
            UInt32 AudioSession = kAudioSessionCategory_PlayAndRecord;
            m_nAudioSessionCategory = AudioSession;
        
            AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(AudioSession), &AudioSession);
            
            UInt32 allowMix = true;
            
            AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(allowMix),                     &allowMix);
        }
    }
    else
    {
        if(m_nAudioSessionCategory != kAudioSessionCategory_MediaPlayback)
        {
            UInt32 AudioSession = kAudioSessionCategory_MediaPlayback;
            m_nAudioSessionCategory = AudioSession;
        
            AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(AudioSession), &AudioSession);
            
            UInt32 allowMix = true;
            
            AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(allowMix),                     &allowMix);
        }
    }
    
    if(m_bMediaSpeakerPhone)
    {
        [cAudioMedia SetMediaRoute: AUDIO_MEDIA_SPEAKER];
    }
    else if(m_bMediaDisablingSpeakerPhone)
    {
        m_bMediaDisablingSpeakerPhone = false;
        [cAudioMedia SetMediaRoute: m_nMediaStoredSpeakerPhoneId];
    }
    else if(m_bVaxMediaCaptured)
    {
        if(nAudioMediaId == AUDIO_MEDIA_SPEAKER)
            nAudioMediaId = AUDIO_MEDIA_RECEIVER_AND_MIC;
        
        [cAudioMedia SetMediaRoute: nAudioMediaId];
    }
    else
    {
        if(nAudioMediaId == AUDIO_MEDIA_RECEIVER_AND_MIC)
            nAudioMediaId = AUDIO_MEDIA_SPEAKER;
        
        [cAudioMedia SetMediaRoute: nAudioMediaId];
    }
}

+ (int) GetMediaRoute;
{
    #if TARGET_IPHONE_SIMULATOR
        // set to NO in simulator. Code causes crashes for some reason.
        return AUDIO_MEDIA_NONE;
    #endif
    
    CFStringRef sDeviceName;
    UInt32 propertySize = sizeof(CFStringRef);
    
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &sDeviceName);
    
    NSString* pDeviceName = (__bridge NSString*) sDeviceName;
    
    NSLog(@"%@\n", sDeviceName);
    
    int nDevice = AUDIO_MEDIA_NONE;
    
    if([pDeviceName caseInsensitiveCompare: @"Speaker"] == NSOrderedSame || [pDeviceName caseInsensitiveCompare: @"SpeakerAndMicrophone"] == NSOrderedSame)
        nDevice = AUDIO_MEDIA_SPEAKER;
    
    else if([pDeviceName caseInsensitiveCompare: @"Headphone"] == NSOrderedSame || [pDeviceName caseInsensitiveCompare: @"HeadsetInOut"] == NSOrderedSame)
        nDevice = AUDIO_MEDIA_HEADPHONE;
    
    else if([pDeviceName caseInsensitiveCompare: @"ReceiverAndMicrophone"] == NSOrderedSame)
        nDevice = AUDIO_MEDIA_RECEIVER_AND_MIC;
    
    else if([pDeviceName caseInsensitiveCompare: @"HeadPhonesBT"] == NSOrderedSame || [pDeviceName caseInsensitiveCompare: @"HeadsetBT"] == NSOrderedSame)
        nDevice = AUDIO_MEDIA_BLUE_TOOTH;
    
    CFRelease(sDeviceName);
    
    return nDevice;
}

+ (Boolean) SetMediaRoute :(int) nAudioMediaId;
{
    UInt32 AudioSession = kAudioSessionOverrideAudioRoute_None;
    
    if(nAudioMediaId == AUDIO_MEDIA_NONE)
        AudioSession = kAudioSessionOverrideAudioRoute_None;
    else if(nAudioMediaId == AUDIO_MEDIA_RECEIVER_AND_MIC)
        AudioSession = kAudioSessionOverrideAudioRoute_None;
    else if(nAudioMediaId == AUDIO_MEDIA_HEADPHONE)
        AudioSession = kAudioSessionOverrideAudioRoute_None;
    else if(nAudioMediaId == AUDIO_MEDIA_SPEAKER)
        AudioSession = kAudioSessionOverrideAudioRoute_Speaker;
    else if(nAudioMediaId == AUDIO_MEDIA_BLUE_TOOTH)
        AudioSession = kAudioSessionOverrideAudioRoute_None;
    
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(AudioSession), &AudioSession);
    
    UInt32 nInputBT = 1;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryEnableBluetoothInput, sizeof (nInputBT), &nInputBT);
    
    return true;
}

/////////////////////////////////////////////

+ (void) VaxCaptureMedia;
{
    m_bVaxMediaCaptured = true;
    [cAudioMedia UpdateMedia];
}

+ (void) VaxReleaseMedia;
{
    m_bVaxMediaCaptured = false;
    [cAudioMedia UpdateMedia];
}

/////////////////////////////////////////////

+ (void) SpeakerPhone :(Boolean) bEnable;
{
    if(bEnable)
    {
        m_bMediaSpeakerPhone = true;
        m_nMediaStoredSpeakerPhoneId = [cAudioMedia GetMediaRoute];
        [cAudioMedia UpdateMedia];
    }
    else
    {
        m_bMediaSpeakerPhone = false;
        m_bMediaDisablingSpeakerPhone = true;
        [cAudioMedia UpdateMedia];
    }
}

@end



//#define SESSION_CATAGORY kAudioSessionCategory_MediaPlayback

// kAudioSessionCategory_PlayAndRecord
//kAudioSessionCategory_MediaPlayback
//kAudioSessionCategory_AmbientSound
//kAudioSessionCategory_SoloAmbientSound

/*
 + (void) UpdateSessionCatagory :(Boolean) bDeviceCaptured;
 {
 if(m_nAudioSessionCategory != kAudioSessionCategory_PlayAndRecord)
 {
 UInt32 AudioSession = kAudioSessionCategory_PlayAndRecord;
 m_nAudioSessionCategory = AudioSession;
 
 AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(AudioSession), &AudioSession);
 }
 else
 {
 if(m_nAudioSessionCategory != kAudioSessionCategory_PlayAndRecord)
 {
 UInt32 AudioSession = kAudioSessionCategory_PlayAndRecord;
 m_nAudioSessionCategory = AudioSession;
 
 AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(AudioSession), &AudioSession);
 }
 }
 
 }
 */

