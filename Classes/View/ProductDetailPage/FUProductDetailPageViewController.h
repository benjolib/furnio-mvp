//
//  FUProductDetailPageViewController.h
//  furn
//
//  Created by Stephan Krusche on 18/04/15.
//
//

#import <UIKit/UIKit.h>
#import "FUViewController.h"


@class FUProduct;

@interface FUProductDetailPageViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) FUProduct *product;

@end
