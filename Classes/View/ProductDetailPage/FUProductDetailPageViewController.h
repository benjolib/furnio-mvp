//
//  FUProductDetailPageViewController.h
//  furn
//
//  Created by Stephan Krusche on 18/04/15.
//
//

#import <UIKit/UIKit.h>

#import <GAI.h>

@class FUProduct;

@interface FUProductDetailPageViewController : GAITrackedViewController <UIScrollViewDelegate>

@property (nonatomic, strong) FUProduct *product;

- (instancetype)initWithSingleProduct:(FUProduct *)product;

@end
