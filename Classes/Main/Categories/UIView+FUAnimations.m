//
//  UIView+FUAnimations.m
//  furn
//
//  Created by Markus Bösch on 09/04/15.
//
//

#import "UIView+FUAnimations.h"

static const CGFloat FUAnimateScalingDefaultDuration = 0.2f;
static const CGFloat FUAnimateScalingFactor = 0.85f;

@implementation UIView (FUAnimations)

- (void)animateScaling
{
    [self animateScalingWithDuration:FUAnimateScalingDefaultDuration scale:FUAnimateScalingFactor];
}

- (void)animateScalingWithDuration:(CGFloat)duration scale:(CGFloat)scale
{
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeScale(scale, scale);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }];
}

@end
