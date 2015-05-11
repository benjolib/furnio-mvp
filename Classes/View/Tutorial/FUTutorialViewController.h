//
//  FUTutorialViewController.h
//  furn
//
//  Created by Markus Bösch on 10/05/15.
//
//

#import "FUViewController.h"

typedef NS_ENUM(NSInteger, FUTutorialViewArrow) {
    FUTutorialViewArrowTopLeft,
    FUTutorialViewArrowTopCenter,
    FUTutorialViewArrowTopRight,
    FUTutorialViewArrowCenter,
    FUTutorialViewArrowBottomCenter
};

@interface FUTutorialViewController : FUViewController

- (instancetype)initWithBackgroundView:(UIView *)view circleOrigins:(NSArray *)circleOrigins arrows:(NSArray *)arrows texts:(NSArray *)texts finishedSuffix:(NSString *)finishedSuffix;

@end
