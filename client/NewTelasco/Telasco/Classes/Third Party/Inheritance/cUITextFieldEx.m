//
//  cUITextFieldEx.m
//  Softphone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import "cUITextFieldEx.h"


@implementation cUITextFieldEx

- (void)dealloc
{
    if(mSaveFieldName != NULL)
        [mSaveFieldName release];
    
    [super dealloc];
}

- (void) InitOBJ;
{
    mSaveFieldName = NULL;
    mSaveToMEM = NULL;
    
    mEditingChangedTargetOBJ = NULL;
    mEditingChangedSenderOBJ = NULL;
    mEditingChangedAction = NULL;
    
    m_bEditingDone = false;
    
    self.hidden = true;
    self.secureTextEntry = false;
}

- (void) SetSaveValue;
{
    if(mSaveToMEM != NULL)
    {
        [mSaveToMEM setString: self.text];
    }
    
    if(mSaveFieldName != NULL)
    {
        CFStringRef StoreKey   = CFStringCreateWithCString(kCFAllocatorDefault, [mSaveFieldName UTF8String], kCFStringEncodingUTF8);
    
        CFStringRef StoreValue = CFStringCreateWithCString(kCFAllocatorDefault, [self.text UTF8String], kCFStringEncodingUTF8);
	
        CFPreferencesSetAppValue(StoreKey, StoreValue, kCFPreferencesCurrentApplication);
        CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
	
        CFRelease(StoreKey);
        CFRelease(StoreValue);
    }
}

- (Boolean) GetSaveValue;
{
	if(mSaveToMEM != NULL)
    {
        if([mSaveToMEM length] == 0)
            return false;
        
        [self setText: mSaveToMEM];
        return true;
    }
    
    if(mSaveFieldName != NULL)
	{
        CFStringRef textFieldKey = CFStringCreateWithCString(kCFAllocatorDefault, [mSaveFieldName UTF8String], kCFStringEncodingUTF8);
	
        CFStringRef strRead;
        strRead = (CFStringRef) CFPreferencesCopyAppValue(textFieldKey, kCFPreferencesCurrentApplication);
	
        CFRelease(textFieldKey);
	
        if(strRead == NULL)
		return FALSE;
    
        [self setText :(NSString*) strRead];
	
        CFRelease(strRead);
        return TRUE;
    }
    
    return false;
}

- (void) LoadTextField :(NSString*) sDefaultText :(NSString*) sSaveFieldName :(NSMutableString*) sSaveToMEM;
{
	self.hidden = false;
    
    mEditingChangedTargetOBJ = NULL;
    mEditingChangedSenderOBJ = NULL;
    mEditingChangedAction = NULL;
    
    [self addTarget: self action: @selector(OnEditingDidBegin:) forControlEvents: UIControlEventEditingDidBegin];
    [self addTarget: self action: @selector(OnEditingDidEnd:) forControlEvents: UIControlEventEditingDidEnd];
    [self addTarget: self action: @selector(OnDidEndOnExit:) forControlEvents: UIControlEventEditingDidEndOnExit];
    
    if(sSaveToMEM != NULL)
    {
        mSaveToMEM = sSaveToMEM;
       
        if([self GetSaveValue])
		{
			m_bEditingDone = TRUE;
		}
		else
		{
			m_bEditingDone = FALSE;
			[self setText: sDefaultText];
		}
    }
    else if(sSaveFieldName != NULL)
	{
		mSaveFieldName = [[NSMutableString alloc] init];
		[mSaveFieldName setString: sSaveFieldName];
		
		if([self GetSaveValue])
		{
			m_bEditingDone = TRUE;
		}
		else
		{
			m_bEditingDone = FALSE;
			[self setText: sDefaultText];
		}
	}
	else 
	{
		m_bEditingDone = TRUE;
		[self setText: sDefaultText];
		
		mSaveFieldName = NULL;
	}
}

- (NSString*) GetText;
{
    return self.text;
}

- (void) SetText :(NSString*) pText;
{
    self.text = pText;
    [self SetSaveValue];
}

- (void) SetEventEditingChanged :(id) SenderOBJ :(id) TargetOBJ :(SEL) Action;
{
    mEditingChangedSenderOBJ = SenderOBJ;
    mEditingChangedTargetOBJ = TargetOBJ;
    mEditingChangedAction = Action;
    
    [self addTarget: self action: @selector(OnEditingChanged:) forControlEvents: UIControlEventEditingChanged];
}

- (IBAction) OnEditingChanged:(id)sender;
{
    if(mEditingChangedTargetOBJ == NULL) return;
    [mEditingChangedTargetOBJ performSelector: mEditingChangedAction withObject: mEditingChangedSenderOBJ afterDelay: 0.0];
}

- (IBAction) OnEditingDidBegin:(id)sender;
{
    if(m_bEditingDone) return;
	m_bEditingDone = TRUE;
	
	self.text = @"";
}

- (IBAction) OnEditingDidEnd:(id)sender;
{
	[self SetSaveValue];
}

- (IBAction) OnDidEndOnExit:(id)sender;
{
	
}

- (void) SetTextColorBlack;
{
    self.textColor = [UIColor blackColor];
}

- (void) SetTextColorRed;
{
    self.textColor = [UIColor colorWithRed:238.0/255.0 green:64.0/255.0 blue:54.0/255.0 alpha:1.0];
}

- (void) SetSecureEntry :(Boolean) bEnable;
{
    self.secureTextEntry = bEnable;
}



@end
