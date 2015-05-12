//
//  FUProductManager.m
//  furn
//
//  Created by Markus Bösch on 08/04/15.
//
//

#import "FUProductManager.h"

#import "FUProductList.h"
#import "FUAPIConstants.h"
#import "FUCategory.h"
#import "FULoadingViewManager.h"
#import "FUFilterManager.h"
#import "FUCategoryManager.h"
#import "FURoomList.h"

#import <UIKit/UIKit.h>


static NSUInteger const FUProductManagerRowLimit = 20;

static NSUInteger const FUProductManagerPageSize = 200;

NSString *const FUProductManagerDidFinishLoadingPageNotification = @"FUProductManagerDidFinishLoadingPageNotification";
NSString *const FUProductManagerWillStartLoadingPageNotification = @"FUProductManagerWillStartLoadingPageNotification";

@interface FUProductManager ()

@property (strong, nonatomic) NSMutableArray *products;

@property (strong, nonatomic) NSMutableArray *previousProducts;
@property (strong, nonatomic) FUCategory *previousCategory;
@property (strong, nonatomic) NSString *previousSearchQuery;
@property (strong, nonatomic) NSNumber *previousFoundRows;

@property (assign, nonatomic) BOOL isLoading;

@property (copy, nonatomic) NSNumber *foundRows;

@property (strong, nonatomic) NSMutableSet *removedProducts;

@property (assign, nonatomic) BOOL isDirty;

@end


@implementation FUProductManager

#pragma mark - Initialization

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)setup
{
    [self sharedManager];
}

+ (instancetype)sharedManager
{
    static FUProductManager *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [FUProductManager new];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self setupNotifications];

        [self setupRemovedProducts];

        [self loadProducts];
    }
    
    return self;
}

#pragma mark - Public

- (NSArray *)productsForColumnAtIndex:(NSInteger)index
{
    NSInteger productStart = (index * FUProductManagerRowLimit);
    NSInteger productLimit = productStart + FUProductManagerRowLimit - 1;
    
    if (productLimit < [self.products count]) {
        return [self.products subarrayWithRange:NSMakeRange(productStart, FUProductManagerRowLimit)];
    }
    
    return nil;
}

- (FUProduct *)productAtIndex:(NSInteger)index
{
    if (index < self.products.count) {
        if ((self.products.count - index) < FUProductManagerRowLimit && self.products.count < self.foundRows.integerValue) {
            [self loadProducts];
        }

        return [self.products objectAtIndex:index];
    }

    return nil;
}

- (void)removeProduct:(FUProduct *)product
{
    [self.removedProducts addObject:product.identifier];

    self.isDirty = YES;

    [self.products removeObject:product];
    [self.products removeObject: product];
}

- (void)addProduct:(FUProduct *)product {
    [self.products addObject:product];
}

- (FUProduct *)nextProduct:(FUProduct *)product {
    NSUInteger index = [self.products indexOfObject:product];
    FUProduct *nextProduct = [self productAtIndex:index + 1];
    if (!nextProduct) {
        nextProduct = [self productAtIndex:0];
    }
    
    if ([self.removedProducts containsObject:nextProduct.identifier]) {
        nextProduct = [self nextProduct:nextProduct];
    }

    return nextProduct;
}


- (FUProduct *)productForColumnAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [self absoluteIndexForIndexPath:indexPath];
    
    return [self productAtIndex:index];
}

- (NSInteger)productCount
{
    return self.products.count;
}

- (NSInteger)columnCount
{
    return ceilf(self.productCount / (float)FUProductManagerRowLimit);
}

- (NSInteger)absoluteIndexForIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(indexPath.length == 2, @"Must use an indexPath with length 2.");
    
    NSInteger sectionItemCount = ([indexPath indexAtPosition:0] % self.columnCount) * FUProductManagerRowLimit;
    NSInteger rowItemCount = ([indexPath indexAtPosition:1] % FUProductManagerRowLimit);
    
    return sectionItemCount + rowItemCount;
}

- (NSIndexPath *)absoluteIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = 0;
    NSInteger item = [self absoluteIndexForIndexPath:indexPath];
    
    NSUInteger indices[] = {section, item};

    indexPath = [NSIndexPath indexPathWithIndexes:indices length:2];

    return indexPath;
}

- (void)resetAndLoad:(BOOL)load
{
    if (self.products.count > 0) {
        [self saveCurrentState];
    }

    [self.products removeAllObjects];

    if (load) {
        if (self.previousProducts.count > 0) {
            [self restorePreviousState];
        } else {
            [self loadProducts];
        }
    }
}

- (void)filterSortProducts {
    
    if (self.products.count > 0) {
        [self saveCurrentState];
    }
    
    [self.products removeAllObjects];
    
    _category = nil;
    _searchQuery = nil;
    
    [self loadProducts];
}

- (void)saveCurrentState
{
    _previousProducts = [self.products mutableCopy];
    _previousCategory = [self.category copy];
    _previousSearchQuery = [self.searchQuery copy];
    _previousFoundRows = [self.foundRows copy];
}

- (void)restorePreviousState
{
    _products = [self.previousProducts mutableCopy];
    _category = [self.previousCategory copy];
    _searchQuery = [self.previousSearchQuery copy];
    _foundRows = [self.previousFoundRows copy];
    
    _previousProducts = nil;
    _previousCategory = nil;
    _previousSearchQuery = nil;
    _previousFoundRows = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FUProductManagerDidFinishLoadingPageNotification object:nil];
}

#pragma mark - Notifications

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveRemovedProductIds) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveRemovedProductIds) name:UIApplicationWillTerminateNotification object:nil];
}

- (void)saveRemovedProductIds
{
    if (!self.isDirty) {
        return;
    }

    BOOL success = [NSKeyedArchiver archiveRootObject:self.removedProducts toFile:[self pathForRemovedProducts]];
    
    if (success) {
        self.isDirty = NO;
    }
}

#pragma mark - Getter

- (NSUInteger)currentOffset
{
    return self.products.count;
}

#pragma mark - Setter

- (void)setCategory:(FUCategory *)category
{
    if ((_category.identifier && category.identifier && [_category.identifier isEqualToNumber:category.identifier]) || (!_category && !category)) {
        return;
    }

    [self resetAndLoad:NO];

    _category = category;

    [self loadProducts];
}

- (void)setSearchQuery:(NSString *)searchQuery
{
    if (searchQuery.length > 0) {
        searchQuery = [searchQuery stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }

    if ((_searchQuery && searchQuery && [_searchQuery isEqualToString:searchQuery]) || (!_searchQuery && !searchQuery) ) {
        return;
    }

    [self resetAndLoad:NO];
    
    _searchQuery = searchQuery;
    
    [self loadProducts];
}

#pragma mark - Private

- (void)setupRemovedProducts
{
    NSSet *removedProducts = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForRemovedProducts]];
    
    if (!removedProducts) {
        self.removedProducts = [NSMutableSet set];
    } else {
        self.removedProducts = [removedProducts mutableCopy];
    }

    self.isDirty = NO;
}

- (void)loadProducts
{
    if (self.isLoading) {
        return;
    }

    self.isLoading = YES;
    
    if (!self.products) {
        self.products = [NSMutableArray array];
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@([self currentOffset]) forKey:@"start"];
    [parameters setObject:@(FUProductManagerPageSize) forKey:@"limit"];

    if (self.category) {
        [parameters setObject:self.category.identifier.stringValue forKey:@"category[]"];
        [FULoadingViewManager sharedManger].text = @"SEARCHING PRODUCTS";
    }
    
    else if (self.searchQuery) {
        [parameters setObject:self.searchQuery forKey:@"name"];
        [parameters setObject:self.searchQuery forKey:@"description"];
        [FULoadingViewManager sharedManger].text = @"SEARCHING PRODUCTS";
    }
    
    NSDictionary *filters = [[FUFilterManager sharedManager] filterItems];
    [self addFilterParameters:parameters forFilters:filters];
    
    NSString *sorting = [[FUFilterManager sharedManager] loadSortingString];
    if(sorting && ![sorting isEqualToString:FUSortingNo]) {
        [self addSortingParameters:parameters forSorting:sorting];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FUProductManagerWillStartLoadingPageNotification object:nil];
    
    [JSONHTTPClient getJSONFromURLWithString:[self buildUrlString:FUAPIProducts withParams:parameters] params:nil completion:^(id json, JSONModelError *error) {
        FUProductList *productList = [[FUProductList alloc] initWithDictionary:json error:&error];

        for (FUProduct *product in productList.products) {
            if (![self.removedProducts containsObject:product.identifier]) {
                [self.products addObject:product];
            }
        }
        
        self.foundRows = productList.totalCount;

        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:FUProductManagerDidFinishLoadingPageNotification object:nil];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isLoading = NO;
        });
    }];
}

#pragma mark - Helper

- (void) addSortingParameters:(NSMutableDictionary *)parameters forSorting:(NSString *)sorting {
    NSString *orderProperty;
    NSString *orderDir = @"ASC";
    
    if([sorting isEqualToString:FUSortingPriceHighToLow]) {
        orderDir = @"DESC";
        orderProperty = @"price";
    }
    else if([sorting isEqualToString:FUSortingPriceLowToHigh]) {
        orderProperty = @"price";
    }
    else if([sorting isEqualToString:FUSortingCategory]) {
        orderProperty = @"categories";
    }
    else if([sorting isEqualToString:FUSortingMerchant]) {
        orderProperty = @"seller";
    }
    else if([sorting isEqualToString:FUSortingAllTimePopular]) {
        orderProperty = @"id";
    }
    else if([sorting isEqualToString:FUSortingNewlyFeatured]) {
        orderDir = @"DESC";
        orderProperty = @"id";
    }
    
    [parameters setObject:orderProperty forKey:@"orderProperty"];
    [parameters setObject:orderDir forKey:@"orderDir"];
}

- (void) addFilterParameters:(NSMutableDictionary *)parameters forFilters:(NSDictionary *)filters {
    NSDictionary *filterCategories = filters[FUFilterCategoryKey];
    NSDictionary *filterStyles = filters[FUFilterStyleKey];
    NSDictionary *filterRooms = filters[FUFilterRoomKey];
    NSDictionary *filterPrice = filters[FUFilterPriceKey];
    
    NSMutableArray *categories = [NSMutableArray array];
    for (NSString *categoryName in filterCategories) {
        if([filterCategories[categoryName] boolValue] == YES) {
            NSNumber *categoryId = [[FUFilterManager sharedManager] categoryIdentifierForName:categoryName];
            if(categoryId) {
                [categories addObject:categoryId];
            }
        }
    }
    if ([categories count] > 0) {
        [parameters setObject: categories forKey:@"category[]"];
    }
    
    NSMutableArray *styles = [NSMutableArray array];
    for (NSString *styleName in filterStyles) {
        if([filterStyles[styleName] boolValue] == YES) {
            [styles addObject:styleName];
        }
    }
    if ([categories count] > 0) {
        [parameters setObject: styles forKey:@"property[Style]"];
    }
    
    NSMutableArray *rooms = [NSMutableArray array];
    for (NSString *roomName in filterRooms) {
        if([filterRooms[roomName] boolValue] == YES) {
            NSString *roomId = [[FUFilterManager sharedManager] roomIdForName:roomName];
            if(roomId) {
                [rooms addObject:roomId];
            }
        }
    }
    if ([rooms count] > 0) {
        [parameters setObject:rooms forKey:@"room"];
    }

    NSString *priceFrom = [filterPrice[FUMinPriceKey] stringValue];
    NSString *priceTo = [filterPrice[FUMaxPriceKey] stringValue];
    
    if (!priceFrom) {
        priceFrom = [FUMinPriceDefaultValue stringValue];
    }
    
    if (!priceTo) {
        priceTo = [FUMaxPriceDefaultValue stringValue];
    }

    [parameters setObject:priceFrom forKey:@"priceFrom"];
    [parameters setObject:priceTo forKey:@"priceTo"];
}

- (NSString *)pathForRemovedProducts
{
    NSString *path;
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    if (documentsDirectory) {
        path = [documentsDirectory stringByAppendingPathComponent:@"removed.plist"];
    }

    return path;
}

- (NSString *)buildUrlString:(NSString*)urlBaseString withParams:(NSDictionary *)params {
    NSMutableString *paramsString = [NSMutableString stringWithString:@""];
    for (NSString* key in [[params allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
        if ([params[key] isKindOfClass:[NSArray class]]) {
            for(NSString *value in params[key]) {
                [paramsString appendFormat:@"%@=%@&", key, [FUProductManager urlEncode:value]];
            }
        }
        else {
            [paramsString appendFormat:@"%@=%@&", key, [FUProductManager urlEncode:params[key]]];
        }
    }
    if ([paramsString hasSuffix:@"&"]) {
        paramsString = [[NSMutableString alloc] initWithString: [paramsString substringToIndex: paramsString.length-1]];
    }

    return [NSString stringWithFormat: @"%@%@%@", urlBaseString, @"?", paramsString];
}

+(NSString*)urlEncode:(id<NSObject>)value
{
    //make sure param is a string
    if ([value isKindOfClass:[NSNumber class]]) {
        value = [(NSNumber*)value stringValue];
    }
    
    NSAssert([value isKindOfClass:[NSString class]], @"request parameters can be only of NSString or NSNumber classes. '%@' is of class %@.", value, [value class]);
    
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef) value,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
}

@end
