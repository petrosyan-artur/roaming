//
//  TRecentCallCell.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/25/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TRecentCallCell.h"
#import <QuartzCore/QuartzCore.h>

@interface TRecentCallCellInputOverlay : UIView

@property (nonatomic, weak) TRecentCallCell * currentCell;

@end

@implementation TRecentCallCell
{
    TRecentCallCellInputOverlay *tableInputOverlay;
}

- (void)awakeFromNib {
    self.avatarImg.layer.cornerRadius = 17;
    self.avatarImg.clipsToBounds = YES;
}

//-(UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
////    if (_currentCell && CGRectContainsPoint(_currentCell.bounds, [self convertPoint:point toView:_currentCell])) {
////        return nil;
////    }
////    [_currentCell hideSwipeAnimated:YES];
//    [self hideUtilityButtonsAnimated:YES];
//    return nil;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initWithName:(NSString *)name phoneNumber:(NSString *)phoneNumber avatar:(UIImage *)avatar ringCount:(int)ringCount date:(NSString *)date
{
    self.avatarImg.image  = (avatar) ? avatar : [UIImage imageNamed:@"avatar"];
    self.dateLbl.text = [NSString stringWithFormat:@"%@", date];
    self.dateLbl.frame = CGRectMake(self.phoneNumberLbl.frame.origin.x, self.dateLbl.frame.origin.y, self.dateLbl.frame.size.width, self.dateLbl.frame.size.height);
    NSString *countStr = (ringCount == 1) ? @"" : [NSString stringWithFormat:@"(%i)", ringCount];
    self.phoneNumberLbl.text = [NSString stringWithFormat:@"%@ %@", ((name) ? name : phoneNumber), countStr];
}

@end
