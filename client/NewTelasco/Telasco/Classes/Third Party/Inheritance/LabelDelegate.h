//
//  LabelDelegate.h
//  Telasco
//
//  Created by Janna Hakobyan on 4/13/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LabelDelegate <NSObject>

- (void)pasteDone:(NSString*)pasteString;
- (void)textBecameEmpty;
- (void)textBecameNotEmpty;
@end
