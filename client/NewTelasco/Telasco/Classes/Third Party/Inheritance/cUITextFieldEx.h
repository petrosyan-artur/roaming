//
//  cUITextFieldEx.h
//  Softphone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface cUITextFieldEx : UITextField 
{
    NSMutableString* mSaveFieldName;
    NSMutableString* mSaveToMEM;
    
    Boolean m_bEditingDone;
    
    id mEditingChangedSenderOBJ;
    id mEditingChangedTargetOBJ;
    SEL mEditingChangedAction;
}

- (void) InitOBJ;
- (void) LoadTextField :(NSString*) sDefaultText :(NSString*) sSaveFieldName :(NSMutableString*) sSaveToMEM;

- (void) SetSecureEntry :(Boolean) bEnable;

- (NSString*) GetText;
- (void) SetText :(NSString*) pText;

- (void) SetTextColorRed;
- (void) SetTextColorBlack;

- (void) SetEventEditingChanged :(id) SenderOBJ :(id) TargetOBJ :(SEL) Action;




@end
