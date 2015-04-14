//
//  cVaxSettings.m
//  VaxPhone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import "AppDelegate.h"
#import "cVaxSettings.h"
#import "cVaxSIPUserAgentEx.h"
#import "cAudioMedia.h"

#define MIC_BOOST_SAVE_FIELD                "SaveFieldMicSoftBoost"
#define SPK_BOOST_SAVE_FIELD                "SaveFieldSpkSoftBoost"

#define MIC_AUTO_GAIN_SAVE_FIELD            "SaveFieldMicAutoGain"
#define SPK_AUTO_GAIN_SAVE_FIELD            "SaveFieldSpkAutoGain"

#define AEC_SAVE_FIELD                      "SaveFieldEchoCancellation"
#define MULTI_TASK_SAVE_FIELD               "SaveFieldMultiTask"
#define DIAGNOSTIC_LOG_SAVE_FIELD           "SaveFieldDiagnosticLog"

#define VOICE_CODEC_NO_SAVE_FIELD           "SaveFieldVoiceCodecsNo"
#define VOICE_CODEC_STATE_SAVE_FIELD        "SaveFieldVoiceCodecsState"

#define VOICE_CHANGER_PITCH_SAVE_FIELD      "SaveFieldVoiceChangerPitch"

#define SIP_LISTEN_PORT_SAVE_FIELD          "SaveFieldListenPortSIP"
#define SIP_CHOOSE_RANDOM_SAVE_FIELD        "SaveFieldChoosePortRandomSIP"

#define RTP_LISTEN_PORT_SAVE_FIELD          "SaveFieldListenPortRTP"
#define RTP_CHOOSE_RANDOM_SAVE_FIELD        "SaveFieldChoosePortRandomRTP"

#define MISSED_CALL_BADGECOUNT_SAVE_FIELD    "SaveFieldMissedCallBadgeCount"
#define RING_TONE_SAVE_FIELD                 "SaveFieldRingTone"

#define NETWORK_AUTO_REGISTER_SAVE_FIELD     "SaveFieldNetworkAutoRegister"

#define CRYPT_TUNNEL_IP_SAVE_FIELD           "SaveFieldCryptTunnelIP"
#define CRYPT_TUNNEL_PORT_SAVE_FIELD         "SaveFieldCryptTunnelPort"
#define CRYPT_TUNNEL_ENABLE_SAVE_FIELD       "SaveFieldCryptTunnelEnable"


@implementation cVaxSettings

- (id) init;
{	
    self = [super init];
    
    mbVoiceChangerState = false;
    mbSpeakerPhoneState = false;
    
	return self;
}

- (void) dealloc;
{	
    [super dealloc];
}

- (void) LoadSettingAll;
{
    [self LoadRingTone];
    [self LoadListenPortSIP];
    [self LoadListenPortRTP];
    
    [self LoadMicBoost];
    [self LoadSpkBoost];
    
    [self LoadMicAutoGain];
    [self LoadSpkAutoGain];
    
    [self LoadAEC];
    [self LoadVoiceCodec];
    
    [self LoadVoiceChanger];
    [self LoadMultiTask];
    [self LoadDiagnosticLog];
    
    [self LoadNetworkAutoRegister];
    [self LoadCryptTunnel];
}

- (void) ArraySetSaveValue :(NSString*) sFieldName :(NSArray*) aValue;
{
    CFPreferencesSetAppValue((CFStringRef) sFieldName, aValue, kCFPreferencesCurrentApplication);
	CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
}

- (Boolean) ArrayGetSaveValue :(NSString*) sFieldName :(NSMutableArray*) aValue;
{
    NSArray* aRead = (NSArray*) CFPreferencesCopyAppValue((CFStringRef) sFieldName, kCFPreferencesCurrentApplication);
	
    if(aRead == NULL) return false;
    
    for(int nCount = 0; nCount < aRead.count; nCount++)
    {
        [aValue addObject: [aRead objectAtIndex: nCount]];
    }
        
	CFRelease(aRead);
    return true;
}


- (void) BoolSetSaveValue :(NSString*) sFieldName :(Boolean) bValue;
{
    CFPreferencesSetAppValue((CFStringRef) sFieldName, [NSNumber numberWithBool: bValue], kCFPreferencesCurrentApplication);
    
	CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
}

- (Boolean) BoolGetSaveValue :(NSString*) sFieldName :(Boolean*) pValue;
{
    NSNumber* nRead = (NSNumber*) CFPreferencesCopyAppValue((CFStringRef) sFieldName, kCFPreferencesCurrentApplication);
	
    if(nRead == NULL) return false;
    
    *pValue = [nRead boolValue];
	CFRelease(nRead);
	
    return true;
}

- (void) IntSetSaveValue :(NSString*) sFieldName :(int) nValue;
{
    CFPreferencesSetAppValue((CFStringRef) sFieldName, [NSNumber numberWithInt: nValue], kCFPreferencesCurrentApplication);
    
	CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
}

- (Boolean) IntGetSaveValue :(NSString*) sFieldName :(int*) pValue;
{
    NSNumber* nRead = (NSNumber*) CFPreferencesCopyAppValue((CFStringRef) sFieldName, kCFPreferencesCurrentApplication);
	
    if(nRead == NULL) return false;
    
    *pValue = [nRead intValue];
	CFRelease(nRead);
	
    return true;
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (void) StringSetSaveValue :(NSString*) sFieldName :(NSString*) sValue;
{
    CFPreferencesSetAppValue((CFStringRef) sFieldName, sValue, kCFPreferencesCurrentApplication);
    
    CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
}

- (Boolean) StringGetSaveValue :(NSString*) sFieldName :(NSMutableString*) sValue;
{
    NSString* sRead = (NSString*) CFPreferencesCopyAppValue((CFStringRef) sFieldName, kCFPreferencesCurrentApplication);
    if(sRead == NULL) return false;
    
    [sValue setString: sRead];
    CFRelease(sRead);
    
    return true;
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

- (void) LoadMicBoost;
{
    [[cVaxSIPUserAgentEx GetOBJ] MicSetSoftBoost: [self GetMicBoost]];
}

- (Boolean) SetMicBoost :(Boolean) bEnable;
{
    [[cVaxSIPUserAgentEx GetOBJ] MicSetSoftBoost: bEnable];
    [self BoolSetSaveValue: @MIC_BOOST_SAVE_FIELD: bEnable];
    
    return true;
}

- (Boolean) GetMicBoost;
{
    Boolean bEnable;
    
    if(![self BoolGetSaveValue: @MIC_BOOST_SAVE_FIELD: &bEnable])
        return false;
    
    return bEnable;
}

- (void) LoadSpkBoost;
{
    [[cVaxSIPUserAgentEx GetOBJ] SpkSetSoftBoost: [self GetSpkBoost]];
}

- (Boolean) SetSpkBoost :(Boolean) bEnable;
{
    [[cVaxSIPUserAgentEx GetOBJ] SpkSetSoftBoost: bEnable];
    [self BoolSetSaveValue: @SPK_BOOST_SAVE_FIELD: bEnable];
    
    return true;
}

- (Boolean) GetSpkBoost;
{
    Boolean bEnable;
    
    if(![self BoolGetSaveValue: @SPK_BOOST_SAVE_FIELD: &bEnable])
        return false;
    
    return bEnable;
}

- (void) LoadAEC;
{
    [[cVaxSIPUserAgentEx GetOBJ] SetEchoCancellation: [self GetAEC]];
}

- (Boolean) SetAEC :(Boolean) bEnable;
{
    [[cVaxSIPUserAgentEx GetOBJ] SetEchoCancellation: bEnable];
    [self BoolSetSaveValue: @AEC_SAVE_FIELD: bEnable];
    
    return true;
}

- (Boolean) GetAEC;
{
    Boolean bEnable;
    
    if(![self BoolGetSaveValue: @AEC_SAVE_FIELD: &bEnable])
        return true;
    
    return bEnable;
}

- (void) LoadMultiTask;
{
    [[cVaxSIPUserAgentEx GetOBJ] BackgroundMode: [self GetMultiTask]];
}

- (Boolean) SetMultiTask :(Boolean) bEnable;
{
    [[cVaxSIPUserAgentEx GetOBJ] BackgroundMode: bEnable];
    [self BoolSetSaveValue: @MULTI_TASK_SAVE_FIELD: bEnable];
    
    return true;
}

- (Boolean) GetMultiTask;
{
    Boolean bEnable;
    
    if(![self BoolGetSaveValue: @MULTI_TASK_SAVE_FIELD: &bEnable])
        return true;
    
    return bEnable;
}

//////////////////////////////////////

- (void) LoadDiagnosticLog;
{
    [[cVaxSIPUserAgentEx GetOBJ] DiagnosticLog: [self GetDiagnosticLog]];
}

- (Boolean) SetDiagnosticLog :(Boolean) bEnable;
{
    [[cVaxSIPUserAgentEx GetOBJ] DiagnosticLog: bEnable];
    [self BoolSetSaveValue: @DIAGNOSTIC_LOG_SAVE_FIELD: bEnable];
    
    return true;
}

- (Boolean) GetDiagnosticLog;
{
    Boolean bEnable;
    
    if(![self BoolGetSaveValue: @DIAGNOSTIC_LOG_SAVE_FIELD: &bEnable])
        return false;
    
    return bEnable;
}

/////////////////////////////////////

- (void) LoadMicAutoGain;
{
    [[cVaxSIPUserAgentEx GetOBJ] MicSetAutoGain: [self MicGetAutoGain]];
}

- (Boolean) MicSetAutoGain :(int) nValue;
{
    [[cVaxSIPUserAgentEx GetOBJ] MicSetAutoGain: nValue];
    [self IntSetSaveValue: @MIC_AUTO_GAIN_SAVE_FIELD: nValue];
    
    return true;
}

- (int) MicGetAutoGain;
{
    int nValue;
    
    if(![self IntGetSaveValue: @MIC_AUTO_GAIN_SAVE_FIELD: &nValue])
        return 0;
    
    return nValue;
}



- (void) LoadSpkAutoGain;
{
    [[cVaxSIPUserAgentEx GetOBJ] SpkSetAutoGain: [self SpkGetAutoGain]];
}

- (Boolean) SpkSetAutoGain :(int) nValue;
{
    [[cVaxSIPUserAgentEx GetOBJ] SpkSetAutoGain: nValue];
    [self IntSetSaveValue: @SPK_AUTO_GAIN_SAVE_FIELD: nValue];
    
    return true;
}

- (int) SpkGetAutoGain;
{
    int nValue;
    
    if(![self IntGetSaveValue: @SPK_AUTO_GAIN_SAVE_FIELD: &nValue])
        return 0;
    
    return nValue;
}


- (void) LoadVoiceCodec;
{
    NSMutableArray* aCodecNo = [[NSMutableArray new] autorelease];
    NSMutableArray* aCodecState = [[NSMutableArray new] autorelease];
    
    [self GetVoiceCodec: aCodecNo: aCodecState];
    
    NSMutableArray* aVaxListCodecNo = [[NSMutableArray new] autorelease];
    
    for(int nCount = 0; nCount < aCodecNo.count; nCount++)
    {
        if([[aCodecState objectAtIndex: nCount] boolValue])
        {
            [aVaxListCodecNo addObject: [aCodecNo objectAtIndex: nCount]];
        }
    }
    
    [[cVaxSIPUserAgentEx GetOBJ] SetVoiceCodecs: aVaxListCodecNo];
}

- (Boolean) SetVoiceCodec :(NSArray*) aCodecNo :(NSArray*) aCodecState;
{
    NSMutableArray* aVaxListCodecNo = [[NSMutableArray new] autorelease];
    
    for(int nCount = 0; nCount < aCodecNo.count; nCount++)
    {
        if([[aCodecState objectAtIndex: nCount] boolValue])
        {
            [aVaxListCodecNo addObject: [aCodecNo objectAtIndex: nCount]];
        }
    }
    
    [[cVaxSIPUserAgentEx GetOBJ] SetVoiceCodecs: aVaxListCodecNo];
    
    [self ArraySetSaveValue: @VOICE_CODEC_NO_SAVE_FIELD :(NSArray*) aCodecNo];
    [self ArraySetSaveValue: @VOICE_CODEC_STATE_SAVE_FIELD :(NSArray*) aCodecState];
    
    return true;
}

- (void) GetVoiceCodec :(NSMutableArray*) aCodecNo :(NSMutableArray*) aCodecState;
{
    [aCodecNo removeAllObjects];
    [aCodecState removeAllObjects];
    
    if(![self ArrayGetSaveValue: @VOICE_CODEC_NO_SAVE_FIELD: aCodecNo])
    {
        [aCodecNo addObject: [NSNumber numberWithInt: VAX_CODEC_G711U]];
        [aCodecNo addObject: [NSNumber numberWithInt: VAX_CODEC_G711A]];
        [aCodecNo addObject: [NSNumber numberWithInt: VAX_CODEC_GSM610]];
        [aCodecNo addObject: [NSNumber numberWithInt: VAX_CODEC_ILBC]];
        [aCodecNo addObject: [NSNumber numberWithInt: VAX_CODEC_OPUS]];
        
        [aCodecState addObject: [NSNumber numberWithBool: YES]];
        [aCodecState addObject: [NSNumber numberWithBool: YES]];
        [aCodecState addObject: [NSNumber numberWithBool: YES]];
        [aCodecState addObject: [NSNumber numberWithBool: YES]];
        [aCodecState addObject: [NSNumber numberWithBool: YES]];
        
        return;
    }
    
    if(![self ArrayGetSaveValue: @VOICE_CODEC_STATE_SAVE_FIELD: aCodecState])
    {
        [aCodecState addObject: [NSNumber numberWithBool: YES]];
        [aCodecState addObject: [NSNumber numberWithBool: YES]];
        [aCodecState addObject: [NSNumber numberWithBool: YES]];
        [aCodecState addObject: [NSNumber numberWithBool: YES]];
        [aCodecState addObject: [NSNumber numberWithBool: YES]];
        
        return;
    }
}


- (void) LoadVoiceChanger;
{
    Boolean bState = [self GetVoiceChangerState];
    
    if(bState)
    {
        int nPitch = [self GetVoiceChangerPitch];
        [[cVaxSIPUserAgentEx GetOBJ] VoiceChanger: nPitch];
    }
    else
    {
        [[cVaxSIPUserAgentEx GetOBJ] VoiceChanger: -1];
    }
}

- (void) SetVoiceChangerState :(Boolean) bEnable;
{
    if(bEnable)
    {
        mbVoiceChangerState = true;
        
        int nPitch = [self GetVoiceChangerPitch];
        [[cVaxSIPUserAgentEx GetOBJ] VoiceChanger: nPitch];
    }
    else
    {
        [[cVaxSIPUserAgentEx GetOBJ] VoiceChanger: -1];
        mbVoiceChangerState = false;
    }
}

- (Boolean) GetVoiceChangerState;
{
    return mbVoiceChangerState;
}

- (int) GetVoiceChangerPitch;
{
    int nPitch;
    
    if(![self IntGetSaveValue: @VOICE_CHANGER_PITCH_SAVE_FIELD: &nPitch])
        return VAX_VOICE_CHANGER_HELIUM_INHALED;
    
    return nPitch;
}

- (Boolean) SetVoiceChangerPitch :(int) nPitch;
{
    if(mbVoiceChangerState)
        [[cVaxSIPUserAgentEx GetOBJ] VoiceChanger: nPitch];
    
    [self IntSetSaveValue: @VOICE_CHANGER_PITCH_SAVE_FIELD: nPitch];
  
    return true;
}


/////////////////////////////

- (void) LoadListenPortSIP;
{
    Boolean bChooseRandomly;
    int nListenPort;
    
    [self GetListenPortSIP: &bChooseRandomly: &nListenPort];
    
    [[cVaxSIPUserAgentEx GetOBJ] UpdateNetworkSIP: bChooseRandomly: nListenPort];
}

- (Boolean) SetListenPortSIP :(Boolean) bChooseRandomly :(int) nListenPort;
{
    [[cVaxSIPUserAgentEx GetOBJ] UpdateNetworkSIP: bChooseRandomly: nListenPort];
    
    [self IntSetSaveValue: @SIP_LISTEN_PORT_SAVE_FIELD: nListenPort];
    [self BoolSetSaveValue: @SIP_CHOOSE_RANDOM_SAVE_FIELD: bChooseRandomly];
    
    return true;
}

- (void) GetListenPortSIP :(Boolean*) pChooseRandomly :(int*) pListenPort;
{
    Boolean bChooseRandomly;
    int nListenPort;
    
    if(![self IntGetSaveValue: @SIP_LISTEN_PORT_SAVE_FIELD: &nListenPort])
    {
        *pChooseRandomly = true;
        *pListenPort = 5060;
        
        return;
    }

    if(![self BoolGetSaveValue: @SIP_CHOOSE_RANDOM_SAVE_FIELD: &bChooseRandomly])
    {
        *pChooseRandomly = true;
        *pListenPort = 5060;
        
        return;
    }
    
    *pChooseRandomly = bChooseRandomly;
    *pListenPort = nListenPort;
}

/////////////////////////////

- (void) LoadListenPortRTP;
{
    Boolean bChooseRandomly;
    int nListenPort;
    
    [self GetListenPortRTP: &bChooseRandomly: &nListenPort];
    
    [[cVaxSIPUserAgentEx GetOBJ] UpdateNetworkRTP: bChooseRandomly: nListenPort];
}

- (Boolean) SetListenPortRTP :(Boolean) bChooseRandomly :(int) nListenPort;
{
    [[cVaxSIPUserAgentEx GetOBJ] UpdateNetworkRTP: bChooseRandomly: nListenPort];
    
    [self IntSetSaveValue: @RTP_LISTEN_PORT_SAVE_FIELD: nListenPort];
    [self BoolSetSaveValue: @RTP_CHOOSE_RANDOM_SAVE_FIELD: bChooseRandomly];
    
    return true;
}

- (void) GetListenPortRTP :(Boolean*) pChooseRandomly :(int*) pListenPort;
{
    Boolean bChooseRandomly;
    int nListenPort;
    
    if(![self IntGetSaveValue: @RTP_LISTEN_PORT_SAVE_FIELD: &nListenPort])
    {
        *pChooseRandomly = true;
        *pListenPort = 8000;
        
        return;
    }
    
    if(![self BoolGetSaveValue: @RTP_CHOOSE_RANDOM_SAVE_FIELD: &bChooseRandomly])
    {
        *pChooseRandomly = true;
        *pListenPort = 8000;
        
        return;
    }
    
    *pChooseRandomly = bChooseRandomly;
    *pListenPort = nListenPort;
}

//////////////////////////////////////////////////////

- (void) LoadSpeakerPhone;
{
    Boolean bEnable = [self GetSpeakerPhoneState];
    [cAudioMedia SpeakerPhone: bEnable];
}

- (void) SetSpeakerPhoneState :(Boolean) bEnable;
{
    mbSpeakerPhoneState = bEnable;  
    [cAudioMedia SpeakerPhone: bEnable];
}

- (Boolean) GetSpeakerPhoneState;
{
    return mbSpeakerPhoneState;
}

//////////////////////////////////////////////////////

- (void) ResetSettingAll;
{
    [self SetMicBoost: false];
    [self SetSpkBoost: false];
   
    [self MicSetAutoGain: 0];
    [self SpkSetAutoGain: 0];
    
    [self SetAEC: true];
    [self SetMultiTask: true];
    
    [self SetDiagnosticLog: false];
    
     NSMutableArray* aCodecNo = [[NSMutableArray new] autorelease];
     NSMutableArray* aCodecState = [[NSMutableArray new] autorelease];
    
    [aCodecNo addObject: [NSNumber numberWithInt: VAX_CODEC_G711U]];
    [aCodecNo addObject: [NSNumber numberWithInt: VAX_CODEC_G711A]];
    [aCodecNo addObject: [NSNumber numberWithInt: VAX_CODEC_GSM610]];
    [aCodecNo addObject: [NSNumber numberWithInt: VAX_CODEC_ILBC]];
    [aCodecNo addObject: [NSNumber numberWithInt: VAX_CODEC_OPUS]];
    
    [aCodecState addObject: [NSNumber numberWithBool: YES]];
    [aCodecState addObject: [NSNumber numberWithBool: YES]];
    [aCodecState addObject: [NSNumber numberWithBool: YES]];
    [aCodecState addObject: [NSNumber numberWithBool: YES]];
    [aCodecState addObject: [NSNumber numberWithBool: YES]];
    
    [self SetVoiceCodec :(NSArray*) aCodecNo :(NSArray*) aCodecState];
    [self SetVoiceChangerPitch: VAX_VOICE_CHANGER_HELIUM_INHALED];
    
    [self SetListenPortSIP: true: 5060];
    [self SetListenPortRTP: true: 8000];
}

/////////////////////////////////////////////////////

- (void) LoadRingTone;
{
    [[cVaxSIPUserAgentEx GetOBJ] ApplyRingTone: [self GetRingTone]];
}

- (Boolean) SetRingTone :(int) nRingToneId;
{
    [[cVaxSIPUserAgentEx GetOBJ] ApplyRingTone: nRingToneId];
    [self IntSetSaveValue: @RING_TONE_SAVE_FIELD: nRingToneId];
    
    return true;
}

- (int) GetRingTone;
{
    int nRingToneId;
    
    if(![self IntGetSaveValue: @RING_TONE_SAVE_FIELD: &nRingToneId])
        return VAX_RING_TONE_ELEGANT;
    
    return nRingToneId;
}

//////////////////////////////////////////////////////

- (void) LoadNetworkAutoRegister;
{
    [[cVaxSIPUserAgentEx GetOBJ] SetNetworkAutoRegister: [self GetNetworkAutoRegister]];
}

- (Boolean) SetNetworkAutoRegister :(Boolean) bEnable;
{
    [[cVaxSIPUserAgentEx GetOBJ] SetNetworkAutoRegister: bEnable];
    [self BoolSetSaveValue: @NETWORK_AUTO_REGISTER_SAVE_FIELD: bEnable];
    
    return true;
}

- (Boolean) GetNetworkAutoRegister;
{
    Boolean bEnable;
    
    if(![self BoolGetSaveValue: @NETWORK_AUTO_REGISTER_SAVE_FIELD: &bEnable])
        return true;
    
    return bEnable;
}

//////////////////////////////////////////////////////

- (void) LoadCryptTunnel;
{
    Boolean bEnable = false;
    NSMutableString* sTunnelServerIP = [[NSMutableString alloc] init];
    int nTunnelServerPort;
    
    if(![self GetCryptTunnel :&bEnable :sTunnelServerIP :&nTunnelServerPort])
    {
        [sTunnelServerIP release];
        return;
    }
    
    [[cVaxSIPUserAgentEx GetOBJ] CryptCOMM :bEnable :sTunnelServerIP :nTunnelServerPort];
    [sTunnelServerIP release];
}

- (Boolean) SetCryptTunnel :(Boolean) bEnable :(NSString*) sTunnelServerIP :(int) nTunnelServerPort;
{
    [[cVaxSIPUserAgentEx GetOBJ] CryptCOMM :bEnable :sTunnelServerIP :nTunnelServerPort];
     
    [self BoolSetSaveValue: @CRYPT_TUNNEL_ENABLE_SAVE_FIELD: bEnable];
    [self StringSetSaveValue: @CRYPT_TUNNEL_IP_SAVE_FIELD: sTunnelServerIP];
    [self IntSetSaveValue: @CRYPT_TUNNEL_PORT_SAVE_FIELD: nTunnelServerPort];
    
    return true;
}

- (Boolean) GetCryptTunnel :(Boolean*) bEnable :(NSMutableString*) sTunnelServerIP :(int*) nTunnelServerPort;
{
    if(![self BoolGetSaveValue: @CRYPT_TUNNEL_ENABLE_SAVE_FIELD: bEnable])
    {
        *bEnable = false;
        [sTunnelServerIP setString: @"<Tunnel Server IP>"];
         *nTunnelServerPort = 8891;
        
         return false;
    }

    if(![self StringGetSaveValue: @CRYPT_TUNNEL_IP_SAVE_FIELD: sTunnelServerIP])
    {
        *bEnable = false;
        [sTunnelServerIP setString: @"<Tunnel Server IP>"];
        *nTunnelServerPort = 8891;
        
        return false;
    }
    
    if(![self IntGetSaveValue: @CRYPT_TUNNEL_PORT_SAVE_FIELD: nTunnelServerPort])
    {
        *bEnable = false;
        [sTunnelServerIP setString: @"<Tunnel Server IP>"];
        *nTunnelServerPort = 8891;
        
        return false;
    }

    return true;

}


@end
