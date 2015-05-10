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

@interface FUFilterManager ()

@property (nonatomic, strong) NSMutableDictionary *allFilterItems;
@property (nonatomic, strong) NSMutableDictionary *categoryIdMappings;

@end

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

- (NSDictionary *)filterItems {
    if (!_allFilterItems) {
        [self loadAllFilterItems];
    }
    return [_allFilterItems copy];
}

- (NSMutableDictionary *)makeInnerMutable:(NSMutableDictionary *)dictionary {
    for (NSString *key in [dictionary allKeys]) {
        dictionary[key] = [dictionary[key] mutableCopy];
    }
    return dictionary;
}

- (NSMutableDictionary *)loadAllFilterItems {
    _allFilterItems = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:FUFilterItemsKey] mutableCopy];
    
    if(!_allFilterItems) {
        [self setupAllFilterItems];
        _allFilterItems = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:FUFilterItemsKey] mutableCopy];
        _allFilterItems = [self makeInnerMutable:_allFilterItems];
    }
    else {
        _allFilterItems = [self makeInnerMutable:_allFilterItems];
        //reload categories in case there is a new one:
        BOOL changed = NO;
        if(!_categoryIdMappings) {
            _categoryIdMappings = [[NSUserDefaults standardUserDefaults] objectForKey:FUFilterCategoryMappingKey];
        }
        for(FUCategory *category in [FUCategoryManager sharedManager].categoryList.categories) {
            if(![[_allFilterItems[FUFilterCategoryKey] allValues] containsObject:category.identifier]) {
                _allFilterItems[FUFilterCategoryKey][category.name] = @NO;
                changed = YES;
            }
            _categoryIdMappings[category.name] = category.identifier;
        }
        if ([_categoryIdMappings count] > 0) {
            [[NSUserDefaults standardUserDefaults] setValue:_categoryIdMappings forKey:@"FUFilterCategoryMapping"];
        }

        if(changed) {
            [self saveAllFilterItems:_allFilterItems];
        }
    }
    
    return [_allFilterItems mutableCopy];
}

- (void)saveAllFilterItems:(NSMutableDictionary *)allFilterItems {
    _allFilterItems = allFilterItems;
    [[NSUserDefaults standardUserDefaults] setValue:allFilterItems forKey:FUFilterItemsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableDictionary *)defaultCategoriesFilter {
    NSMutableDictionary *filterItemsCategory = [NSMutableDictionary dictionary];
    _categoryIdMappings = [NSMutableDictionary dictionary];
    
    for(FUCategory *category in [FUCategoryManager sharedManager].categoryList.categories) {
        filterItemsCategory[category.name] = @NO;
        _categoryIdMappings[category.name] = category.identifier;
    }
    [[NSUserDefaults standardUserDefaults] setValue:_categoryIdMappings forKey:@"FUFilterCategoryMapping"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return filterItemsCategory;
}

- (NSMutableDictionary *)defaultStylesFilter {
    return [@{@"Contemporary"  : @NO,
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

- (NSMutableDictionary *)defaultFilters {
    return [@{FUFilterCategoryKey : [self defaultCategoriesFilter],
              FUFilterStyleKey    : [self defaultStylesFilter],
              FUFilterRoomKey     : [self defaultRoomsFilter],
              FUFilterPriceKey    : [self defaultPriceFilter]} mutableCopy];
}

- (void)setupAllFilterItems {
    [self saveAllFilterItems: [self defaultFilters]];
}

- (void)resetAllFilters {
    [self setupAllFilterItems];
}

- (NSString *)categoryNameForIdentifier:(NSNumber *)categoryIdentifier {
    if (!_categoryIdMappings) {
        _categoryIdMappings = [[NSUserDefaults standardUserDefaults] objectForKey:FUFilterCategoryMappingKey];
    }

    return [[_categoryIdMappings allKeysForObject:categoryIdentifier] firstObject];
}

- (NSNumber *)categoryIdentifierForName:(NSString *)categoryName {
    if (!_categoryIdMappings) {
        _categoryIdMappings = [[NSUserDefaults standardUserDefaults] objectForKey:FUFilterCategoryMappingKey];
    }
    return _categoryIdMappings[categoryName];
}

@end
