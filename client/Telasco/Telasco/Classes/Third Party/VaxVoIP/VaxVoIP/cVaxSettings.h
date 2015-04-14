//
//  cVaxSettings.h
//  VaxPhone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cVaxSettings : NSObject
{
    Boolean mbVoiceChangerState;
    Boolean mbSpeakerPhoneState;
}

- (id) init;
- (void) dealloc;

- (void) ResetSettingAll;
- (void) LoadSettingAll;

- (void) LoadMicBoost;
- (Boolean) SetMicBoost :(Boolean) bEnable;
- (Boolean) GetMicBoost;

- (void) LoadSpkBoost;
- (Boolean) SetSpkBoost :(Boolean) bEnable;
- (Boolean) GetSpkBoost;

- (void) LoadMicAutoGain;
- (Boolean) MicSetAutoGain :(int) nValue;
- (int) MicGetAutoGain;

- (void) LoadSpkAutoGain;
- (Boolean) SpkSetAutoGain :(int) nValue;
- (int) SpkGetAutoGain;

- (void) LoadAEC;
- (Boolean) SetAEC :(Boolean) bEnable;
- (Boolean) GetAEC;

- (void) LoadMultiTask;
- (Boolean) SetMultiTask :(Boolean) bEnable;
- (Boolean) GetMultiTask;

- (void) LoadDiagnosticLog;
- (Boolean) SetDiagnosticLog :(Boolean) bEnable;
- (Boolean) GetDiagnosticLog;

- (void) LoadVoiceCodec;
- (Boolean) SetVoiceCodec :(NSArray*) aCodecNo :(NSArray*) aCodecState;
- (void) GetVoiceCodec :(NSMutableArray*) aCodecNo :(NSMutableArray*) aCodecState;

- (void) LoadVoiceChanger;
- (void) SetVoiceChangerState :(Boolean) bEnable;
- (Boolean) GetVoiceChangerState;
- (int) GetVoiceChangerPitch;
- (Boolean) SetVoiceChangerPitch :(int) nPitch;

- (void) LoadListenPortSIP;
- (Boolean) SetListenPortSIP :(Boolean) bChooseRandomly :(int) nListenPort;
- (void) GetListenPortSIP :(Boolean*) pChooseRandomly :(int*) pListenPort;

- (void) LoadListenPortRTP;
- (Boolean) SetListenPortRTP :(Boolean) bChooseRandomly :(int) nListenPort;
- (void) GetListenPortRTP :(Boolean*) pChooseRandomly :(int*) pListenPort;

- (void) LoadSpeakerPhone;
- (void) SetSpeakerPhoneState :(Boolean) bEnable;
- (Boolean) GetSpeakerPhoneState;

- (void) LoadRingTone;
- (Boolean) SetRingTone :(int) nRingToneId;
- (int) GetRingTone;

- (void) LoadNetworkAutoRegister;
- (Boolean) SetNetworkAutoRegister :(Boolean) bEnable;
- (Boolean) GetNetworkAutoRegister;

- (Boolean) SetCryptTunnel :(Boolean) bEnable :(NSString*) sTunnelServerIP :(int) nTunnelServerPort;
- (Boolean) GetCryptTunnel :(Boolean*) bEnable :(NSMutableString*) sTunnelServerIP :(int*) nTunnelServerPort;

@end
