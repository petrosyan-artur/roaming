//
//  PhoneNumberLabel.h
//  Telasco
//
//  Created by Janna Hakobyan on 4/13/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "PhoneNumberLabel.h"

@implementation PhoneNumberLabel

@synthesize delegate;

- (void) attachTapHandler
{
    [self setUserInteractionEnabled:YES];
    UIGestureRecognizer *touchy = [[UILongPressGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:touchy];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self attachTapHandler];
    }
    return self;
}

#pragma mark Clipboard

- (void) paste:(id)sender{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    if( pasteboard.string){
        if(delegate){
            [delegate pasteDone:pasteboard.string];
        }
    }
}

- (void) copy:(id)sender{
    NSLog(@"%@",self.text);
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    if (self.text && self.text.length != 0) {
        pasteboard.string = self.text;
    }
}

- (BOOL) canPerformAction: (SEL) action withSender: (id) sender
{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    if( pasteboard.string && action == @selector(paste:)){
        return YES;
    }
    else if (action == @selector(copy:)) {
        if (self.text && self.text.length != 0) {
            return YES;
        }
    }
        
    return NO;
}



- (void) handleTap: (UIGestureRecognizer*) recognizer
{
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if(![menu isMenuVisible]){
        [menu setTargetRect:self.frame inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (void) setText:(NSString *)text{
    NSString* currentText = [[self text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* settedText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [super setText:text];
    
    if([currentText length] > 0 && [settedText length] == 0  ){
        [delegate textBecameEmpty];
    }
    if([currentText length] == 0 && [settedText length] > 0  ){
        [delegate textBecameNotEmpty];
    }
}

@end
