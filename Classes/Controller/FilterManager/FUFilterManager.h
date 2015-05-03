//
//  FUFilterManager.h
//  furn
//
//  Created by Stephan Krusche on 26/04/15.
//
//

#import <Foundation/Foundation.h>

#define FUFilterItemsKey @"FUAllFilterItemsKey"
#define FUFilterCategoryKey @"Category"
#define FUFilterStyleKey @"Style"
#define FUFilterRoomKey @"Room"
#define FUFilterPriceKey @"Price"
#define FUFilterMerchantKey @"Merchant"

#define FUMinPriceKey @"Min Price"
#define FUMaxPriceKey @"Max Price"

#define FUMinPriceDefaultValue @0
#define FUMaxPriceDefaultValue @10000

#define FUSortingKey @"FUSorting"

@class FUProduct;

@interface FUFilterManager : NSObject

+ (instancetype)sharedManager;

- (NSString *)loadSortingString;
- (void)saveSortingString:(NSString *)sortingString;

- (NSMutableDictionary *)loadAllFilterItems;
- (void)saveAllFilterItems:(NSDictionary *)allFilterItems;
- (BOOL)isProductInFilter:(FUProduct *)product;

- (NSMutableDictionary *)defaultFilters;
- (NSMutableDictionary *)defaultCategoriesFilter;
- (NSMutableDictionary *)defaultStylesFilter;
- (NSMutableDictionary *)defaultRoomsFilter;
- (NSMutableDictionary *)defaultPriceFilter;
- (NSMutableDictionary *)defaultMerchantFilter;
@end
