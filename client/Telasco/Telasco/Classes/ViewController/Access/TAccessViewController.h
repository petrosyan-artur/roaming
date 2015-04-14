//
//  TAccessViewController.h
//  Telasco
//
//  Created by Janna Hakobyan on 3/10/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TBaseViewController.h"

@interface TAccessViewController : TBaseViewController

@property (unsafe_unretained) int permission;
@property (nonatomic, weak) IBOutlet UIButton *nextBtn;

- (void)enableAccess;
- (IBAction)next:(id)sender;

@end
