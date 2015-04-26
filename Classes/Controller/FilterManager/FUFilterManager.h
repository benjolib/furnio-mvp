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

@interface FUFilterManager : NSObject

+ (instancetype)sharedManager;
- (NSMutableDictionary *)loadAllFilterItems;
- (void)saveAllFilterItems:(NSDictionary *)allFilterItems;
- (void)resetAllFilters;

@end
