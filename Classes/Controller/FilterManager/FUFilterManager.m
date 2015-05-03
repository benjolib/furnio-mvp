//
//  FUFilterManager.m
//  furn
//
//  Created by Stephan Krusche on 26/04/15.
//
//

#import "FUFilterManager.h"
#import "FUCategoryManager.h"
#import "FUCategoryList.h"
#import "FUCategory.h"
#import "FUProduct.h"
#import "FUProperties.h"
#import "FUSeller.h"

@implementation FUFilterManager

+ (instancetype)sharedManager
{
    static FUFilterManager *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FUFilterManager alloc] init];
    });
    
    return instance;
}

- (NSString *)loadSortingString {
    NSString *sortingString = [[NSUserDefaults standardUserDefaults] stringForKey:FUSortingKey];
    return sortingString;
}

- (void)saveSortingString:(NSString *)sortingString {
    [[NSUserDefaults standardUserDefaults] setValue:sortingString forKey:FUSortingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableDictionary *)loadAllFilterItems {
    NSDictionary *allFilterItems = [[NSUserDefaults standardUserDefaults] dictionaryForKey:FUFilterItemsKey];
    
    if(!allFilterItems) {
        [self setupAllFilterItems];
        allFilterItems = [[NSUserDefaults standardUserDefaults] dictionaryForKey:FUFilterItemsKey];
    }
    
    return [allFilterItems mutableCopy];
}

- (void)saveAllFilterItems:(NSDictionary *)allFilterItems {
    [[NSUserDefaults standardUserDefaults] setValue:allFilterItems forKey:FUFilterItemsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableDictionary *)defaultCategoriesFilter {
    NSMutableDictionary *filterItemsCategory = [NSMutableDictionary dictionary];
    
    for(FUCategory *category in [FUCategoryManager sharedManager].categoryList.categories) {
        filterItemsCategory[category.name] = @NO;
    }
    return filterItemsCategory;
}

- (NSMutableDictionary *)defaultStylesFilter {
    return [@{@"All"           : @NO,
              @"Contemporary"  : @NO,
              @"Ecletic"       : @NO,
              @"Modern"        : @NO,
              @"Traditional"   : @NO,
              @"Asian"         : @NO,
              @"Beach Style"   : @NO,
              @"Craftsman"     : @NO,
              @"Farmhouse"     : @NO,
              @"Industrial"    : @NO,
              @"Rustic"        : @NO,
              @"Southwestern"  : @NO,
              @"Transitional"  : @NO,
              @"Tropical"      : @NO} mutableCopy];
}

- (NSMutableDictionary *)defaultRoomsFilter {
    return [@{@"Kitchen" : @NO,
              @"Bath"    : @NO,
              @"Bedroom" : @NO,
              @"Living"  : @NO,
              @"Dinning" : @NO,
              @"Kids"    : @NO,
              @"Outdoor" : @NO,
              @"Office"  : @NO} mutableCopy];
}

- (NSMutableDictionary *)defaultPriceFilter {
    return [@{FUMinPriceKey : FUMinPriceDefaultValue,
              FUMaxPriceKey : FUMaxPriceDefaultValue} mutableCopy];
}

- (NSMutableDictionary *)defaultMerchantFilter {
    return [@{@"Merchant1" : @NO,
              @"Merchant2" : @NO,
              @"Merchant3" : @NO,
              @"Merchant4" : @NO} mutableCopy];
}

- (NSMutableDictionary *)defaultFilters {
    return [@{FUFilterCategoryKey : [self defaultCategoriesFilter],
              FUFilterStyleKey    : [self defaultStylesFilter],
              FUFilterRoomKey     : [self defaultRoomsFilter],
              FUFilterPriceKey    : [self defaultPriceFilter],
              FUFilterMerchantKey : [self defaultMerchantFilter]} mutableCopy];
}


- (void)setupAllFilterItems {
    [self saveAllFilterItems: [self defaultFilters]];
}

- (void)resetAllFilters {
    [self setupAllFilterItems];
}

- (BOOL)isProductInFilter:(FUProduct *)product {
    
    NSMutableDictionary *allFilterItems = [self loadAllFilterItems];
    NSArray *validCategoryItems = [self validItemsInItems:allFilterItems[FUFilterCategoryKey]];
    NSArray *validStyleItems = [self validItemsInItems:allFilterItems[FUFilterStyleKey]];
    NSArray *validRoomItems = [self validItemsInItems:allFilterItems[FUFilterRoomKey]];
    NSArray *validMerchantItems = [self validItemsInItems:allFilterItems[FUFilterMerchantKey]];

    if([validCategoryItems count] != 0) {
        if(![self product:product matchesCategories:validCategoryItems]) {
            return NO;
        }
    }
    
    if([validStyleItems count] != 0) {
        if(![self product:product matchesStyle:validStyleItems]) {
            return NO;
        }
    }
    
    if([validRoomItems count] != 0) {
        if(![self product:product matchesRoom:validRoomItems]) {
            return NO;
        }
    }
    
    if([validMerchantItems count] != 0) {
        if(![self product:product matchesMerchant:validMerchantItems]) {
            return NO;
        }
    }
    
    if(![self product:product matchesPrice:allFilterItems[FUFilterPriceKey]]) {
        return NO;
    }

    return YES;
}

- (NSArray *)validItemsInItems: (NSDictionary *) filterItems {
    NSMutableArray *validItems = [NSMutableArray array];
    
    for (NSString *key in [filterItems allKeys]) {
        if ([filterItems[key] boolValue]) {
            [validItems addObject:key];
        }
    }
    
    return validItems;
}

- (BOOL) product:(FUProduct *)product matchesCategories:(NSArray *)validCategories {
    for (NSDictionary *productCategoryDictionary in product.categories) {
        for(NSString *validCategory in validCategories) {
            NSString *productCategory = productCategoryDictionary[@"name"];
//            NSLog(@"Product Category: %@", productCategory);
            if ([productCategory isEqualToString:validCategory]) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL) product:(FUProduct *)product matchesStyle:(NSArray *)validStyles {
    for(NSString *validStyle in validStyles) {
        if ([product.properties.designer isEqualToString:validStyle]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) product:(FUProduct *)product matchesPrice:(NSDictionary *)priceLimits {
    
    NSUInteger maxPrice = [priceLimits[FUMaxPriceKey] integerValue];
    NSUInteger minPrice = [priceLimits[FUMinPriceKey] integerValue];
    
    if (minPrice <= [product.price integerValue] && [product.price integerValue] <= maxPrice) {
        return YES;
    }
    return NO;
}

- (BOOL) product:(FUProduct *)product matchesRoom:(NSArray *)validRooms {
    for(NSString *validRoom in validRooms) {
//TODO: there is no "room" property in product
        if ([product.properties.materials isEqualToString:validRoom]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) product:(FUProduct *)product matchesMerchant:(NSArray *)validMerchants {
    for(NSString *validMerchant in validMerchants) {
        if ([product.seller.name isEqualToString:validMerchant]) {
            return YES;
        }
    }
    return NO;
}

@end
