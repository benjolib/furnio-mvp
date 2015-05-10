//
//  FUProductManager.h
//  furn
//
//  Created by Markus Bösch on 08/04/15.
//
//

#import <Foundation/Foundation.h>

@class FUProductList;
@class FUProduct;
@class FUCategory;

extern NSString *const FUProductManagerDidFinishLoadingPageNotification;
extern NSString *const FUProductManagerWillStartLoadingPageNotification;

#define FUSortingNo                 @"No Sorting"
#define FUSortingPriceHighToLow     @"Price (High to Low)"
#define FUSortingPriceLowToHigh     @"Price (Low to High)"
#define FUSortingCategory           @"Category"
#define FUSortingMerchant           @"Merchant"
#define FUSortingAllTimePopular     @"All Time Popular"
#define FUSortingNewlyFeatured      @"Newly Featured"

@interface FUProductManager : NSObject

@property (strong, nonatomic) FUCategory *category;

@property (strong, nonatomic) NSString *searchQuery;

@property (assign, nonatomic, readonly) BOOL isDirty;

+ (void)setup;

+ (instancetype)sharedManager;

- (FUProduct *)productAtIndex:(NSInteger)index;

- (NSArray *)productsForColumnAtIndex:(NSInteger)index;

- (FUProduct *)productForColumnAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)absoluteIndexForIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)absoluteIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)productCount;

- (NSInteger)columnCount;

- (void)resetAndLoad:(BOOL)load;

- (void)filterSortProducts;

- (void)removeProduct:(FUProduct *)product;
- (void)addProduct:(FUProduct *)product;

- (FUProduct *)nextProduct:(FUProduct *)product;

@end
