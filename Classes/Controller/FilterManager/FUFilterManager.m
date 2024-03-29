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
#import "FURoom.h"
#import "FUProperties.h"
#import "FUSeller.h"
#import "FURoomManager.h"
#import "FURoomList.h"

@interface FUFilterManager ()

@property (nonatomic, strong) NSMutableDictionary *allFilterItems;
@property (nonatomic, strong) NSMutableDictionary *categoryIdMappings;
@property (nonatomic, strong) NSMutableDictionary *roomIdMappings;

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
        // is invoked only the very first time the app starts.
        _allFilterItems = [self setupAllFilterItems];
    }
    else {
        _allFilterItems = [self makeInnerMutable:_allFilterItems];
        //reload categories in case there is a new one:
        BOOL changed = NO;
        if(!_categoryIdMappings) {
            _categoryIdMappings = [[[NSUserDefaults standardUserDefaults] objectForKey:FUFilterCategoryMappingKey] mutableCopy];
        }
        if(!_roomIdMappings) {
            _roomIdMappings = [[[NSUserDefaults standardUserDefaults] objectForKey:FUFilterRoomMappingKey] mutableCopy];
        }
        
        for(FUCategory *category in [FUCategoryManager sharedManager].categoryList.categories) {
            if(![[_allFilterItems[FUFilterCategoryKey] allKeys] containsObject:category.name]) {
                _allFilterItems[FUFilterCategoryKey][category.name] = @NO;
                changed = YES;
            }
            _categoryIdMappings[category.name] = category.identifier;
        }
        
        for(FURoom *room in [FURoomManager sharedManager].roomList.rooms) {
            if(![[_allFilterItems[FUFilterRoomKey] allKeys] containsObject:room.name.capitalizedString]) {
                _allFilterItems[FUFilterRoomKey][room.name.capitalizedString] = @NO;
                changed = YES;
            }
            _roomIdMappings[room.name.capitalizedString] = room.identifier;
        }
        
        if ([_categoryIdMappings count] > 0) {
            [[NSUserDefaults standardUserDefaults] setValue:_categoryIdMappings forKey:FUFilterCategoryMappingKey];
        }
        if ([_roomIdMappings count] > 0) {
            [[NSUserDefaults standardUserDefaults] setValue:_roomIdMappings forKey:FUFilterRoomMappingKey];
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
    [[NSUserDefaults standardUserDefaults] setValue:_categoryIdMappings forKey:FUFilterCategoryMappingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return filterItemsCategory;
}

- (NSMutableDictionary *)defaultStylesFilter {
    return [@{@"Contemporary"  : @NO,
              @"Eclectic"      : @NO,
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
    NSMutableDictionary *filterItemsRoom = [@{@"Kitchen" : @NO,
              @"Bath"    : @NO,
              @"Bedroom" : @NO,
              @"Living"  : @NO,
              @"Dining"  : @NO,
              @"Kids"    : @NO,
              @"Outdoor" : @NO,
              @"Office"  : @NO} mutableCopy];
    
    //initial mapping
    _roomIdMappings = [@{@"Kitchen": @"1", @"Bath": @"2", @"Bedroom": @"3", @"Living": @"4", @"Outdoor":@"5", @"Lighting":@"6", @"Decor" : @"7"} mutableCopy];
    
    for(FURoom *room in [FURoomManager sharedManager].roomList.rooms) {
        filterItemsRoom[room.name.capitalizedString] = @NO;
        _roomIdMappings[room.name.capitalizedString] = room.identifier;
    }
    [[NSUserDefaults standardUserDefaults] setValue:_roomIdMappings forKey:FUFilterRoomMappingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return filterItemsRoom;
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

- (NSMutableDictionary *)setupAllFilterItems {
    NSMutableDictionary *defaultFilters = [self defaultFilters];
    [self saveAllFilterItems: defaultFilters];
    return defaultFilters;
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

- (NSString *)roomIdForName:(NSString *)roomName {
    if (!_roomIdMappings) {
        _roomIdMappings = [[NSUserDefaults standardUserDefaults] objectForKey:FUFilterRoomMappingKey];
    }
    return _roomIdMappings[roomName];
}

@end
