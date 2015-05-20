//
//  FUTrackingManager.h
//  furn
//
//  Created by Markus Bösch on 26/04/15.
//
//

#import <Foundation/Foundation.h>

#import "FUProduct.h"
#import "FUCollectionView.h"

@interface FUTrackingManager : NSObject

+ (instancetype)sharedManager;


#pragma mark - Tracking

- (void)trackRateApp;

- (void)trackPDPBuyProduct:(FUProduct *)product;

- (void)trackPDPLikeProduct:(FUProduct *)product;

- (void)trackPDPDislikeProduct:(FUProduct *)product;

- (void)trackPDPShareProduct:(FUProduct *)product;

- (void)trackWishlistRemoveProduct:(FUProduct *)product;

- (void)trackWishlistShareProduct:(FUProduct *)product;

- (void)trackCatalogViewMode:(FUCollectionViewMode)viewMode;

- (void)trackOnboardingResults:(NSArray *)results forScreenIndex:(NSUInteger)index;

@end
