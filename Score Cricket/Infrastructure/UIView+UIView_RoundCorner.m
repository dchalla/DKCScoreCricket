//
//  UIView+UIView_RoundCorner.m
//  Score Cricket
//
//  Created by Dinesh Challa on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+UIView_RoundCorner.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (UIView_RoundCorner)
-(void)makeRoundedCorner:(CGFloat)cornerRadius
{
    CALayer *roundedlayer = [self layer];
    [roundedlayer setMasksToBounds:YES];
    [roundedlayer setCornerRadius:cornerRadius];
}
@end
