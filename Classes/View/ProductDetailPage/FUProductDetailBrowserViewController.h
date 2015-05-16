//
//  FUProductDetailBrowserViewController.h
//  furn
//
//  Created by Stephan Krusche on 25/04/15.
//
//

#import <UIKit/UIKit.h>

#import <GAI.h>

@class FUProduct;

@interface FUProductDetailBrowserViewController : GAITrackedViewController

@property (nonatomic, strong) FUProduct *product;

@end
