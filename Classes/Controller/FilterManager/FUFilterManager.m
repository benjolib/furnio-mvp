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

- (NSMutableDictionary *)loadAllFilterItems {
    NSDictionary *allFilterItems = [[NSUserDefaults standardUserDefaults] dictionaryForKey:FUFilterItemsKey];
    
    if(!allFilterItems) {
        [self setupFilterItems];
        allFilterItems = [[NSUserDefaults standardUserDefaults] dictionaryForKey:FUFilterItemsKey];
    }
    
    return [allFilterItems mutableCopy];
}

- (void)saveAllFilterItems:(NSDictionary *)allFilterItems {
    [[NSUserDefaults standardUserDefaults] setValue:allFilterItems forKey:FUFilterItemsKey];
}

- (void)setupFilterItems {
    
    NSMutableDictionary *filterItemsCategory = [NSMutableDictionary dictionary];
    
    for(FUCategory *category in [FUCategoryManager sharedManager].categoryList.categories) {
        filterItemsCategory[category.name] = @NO;
    }
    
    NSDictionary *filterItemsStyle = [@{@"Style1" : @NO,
                                       @"Style2" : @NO,
                                       @"Style3" : @NO,
                                       @"Style4" : @NO,
                                       @"Style5" : @NO} mutableCopy];

    NSDictionary *filterItemsRoom = [@{@"Room1" : @NO,
                                      @"Room2" : @NO,
                                      @"Room3" : @NO,
                                      @"Room4" : @NO} mutableCopy];
    
    NSDictionary *filterItemsPrice = [@{FUMinPriceKey : @0,
                                       FUMaxPriceKey : @15000} mutableCopy];
    
    NSDictionary *filterItemsMerchant = [@{@"Merchant1" : @NO,
                                          @"Merchant2" : @NO,
                                          @"Merchant3" : @NO,
                                          @"Merchant4" : @NO} mutableCopy];

    
    
    NSDictionary *allFilterItems = [@{FUFilterCategoryKey : filterItemsCategory,
                                     FUFilterStyleKey : filterItemsStyle,
                                     FUFilterRoomKey : filterItemsRoom,
                                     FUFilterPriceKey : filterItemsPrice,
                                     FUFilterMerchantKey : filterItemsMerchant} mutableCopy];
    
    [self saveAllFilterItems:allFilterItems];
}

- (void)resetAllFilters {
    [self setupFilterItems];
}

@end
