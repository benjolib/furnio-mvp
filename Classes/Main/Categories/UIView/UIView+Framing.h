//
//  UIView+Framing.h
//  furn
//
//  Created by Markus Bösch on 01/05/15.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Framing)

/**
 * Same as `self.frame.origin`.
 */
@property (nonatomic, assign) CGPoint origin;

/**
 * Same as `self.frame.size`.
 */
@property (nonatomic, assign) CGSize size;

/**
 * Same as `self.frame.origin.y`.
 */
@property (nonatomic, assign) CGFloat top;

/**
 * Same as `self.frame.origin.x`.
 */
@property (nonatomic, assign) CGFloat left;

/**
 * Same as `self.frame.origin.y + self.frame.height`.
 */
@property (nonatomic, assign) CGFloat bottom;

/**
 * Same as `self.frame.origin.x + self.frame.width`.
 */
@property (nonatomic, assign) CGFloat right;

/**
 * Same as `self.frame.size.width`.
 */
@property (nonatomic, assign) CGFloat width;

/**
 * Same as `self.frame.size.height`.
 */
@property (nonatomic, assign) CGFloat height;

/**
 * Same as `self.center.x`.
 */
@property (nonatomic, assign) CGFloat centerX;

/**
 * Same as `self.center.y`.
 */
@property (nonatomic, assign) CGFloat centerY;

@end
