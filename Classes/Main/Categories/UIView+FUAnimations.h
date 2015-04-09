//
//  UIView+FUAnimations.h
//  furn
//
//  Created by Markus Bösch on 09/04/15.
//
//

#import <UIKit/UIKit.h>

@interface UIView (FUAnimations)

- (void)animateScaling;

- (void)animateScalingWithDuration:(CGFloat)duration scale:(CGFloat)scale;

@end
