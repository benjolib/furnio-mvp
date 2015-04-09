//
//  FUWishlistViewController.h
//  furn
//
//  Created by Markus Bösch on 09/04/15.
//
//

#import "FUViewController.h"

typedef NS_ENUM(NSInteger, FUWishlistViewState) {
    FUWishlistViewStateNormal,
    FUWishlistViewStateEdit
};

@interface FUWishlistViewController : FUViewController

@property (nonatomic, assign, readonly) FUWishlistViewState viewState;

@end
