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


static NSUInteger const FUProductManagerRowLimit = 20;

static NSUInteger const FUProductManagerPageSize = 1000;

NSString *const FUProductManagerDidFinishLoadingPageNotification = @"FUProductManagerDidFinishLoadingPageNotification";
NSString *const FUProductManagerWillStartLoadingPageNotification = @"FUProductManagerWillStartLoadingPageNotification";

@interface FUProductManager ()

@property (strong, nonatomic) NSMutableArray *products;

@property (strong, nonatomic) NSMutableArray *filteredProducts;

@property (assign, nonatomic) BOOL isLoading;

@property (copy, nonatomic) NSNumber *foundRows;

@end


@implementation FUProductManager

#pragma mark - Initialization

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
        [self loadProducts];
    }
    
    return self;
}

#pragma mark - Public

- (void)filterProducts {
    //TODO: also invoke this method at the start of the application and each time new products are load from the server
    
    FUFilterManager *filterManager = [FUFilterManager sharedManager];
    
    for(FUProduct *product in self.products) {
        
        if ([filterManager isProductInFilter:product]) {
            [self.filteredProducts addObject:product];
        }
    }
    
    NSLog(@"Count products: %lu, count filteredProducts: %lu", [self.products count], [self.filteredProducts count]);
}

//TODO: use filteredProducts for most other methods in this class

- (NSArray *)productsForColumnAtIndex:(NSInteger)index
{
    NSInteger productStart = (index * FUProductManagerRowLimit);
    NSInteger productLimit = productStart + FUProductManagerRowLimit - 1;
    
    if (productLimit < self.products.count) {
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

- (void)removeProduct:(FUProduct *)product {
    [self.products removeObject:product];
    //TODO: make sure this product is not shown again if it is loaded again from the server
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
    _category = nil;
    _searchQuery = nil;
    _foundRows = @0;

    [self.products removeAllObjects];

    if (load) {
        [self loadProducts];
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
    
    if (searchQuery.length > 0) {
        [FULoadingViewManager sharedManger].text = @"SEARCHING PRODUCTS";
    }
    
    [self loadProducts];
}

#pragma mark - Private

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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FUProductManagerWillStartLoadingPageNotification object:nil];

    [JSONHTTPClient getJSONFromURLWithString:FUAPIProducts params:parameters completion:^(id json, JSONModelError *error) {
        FUProductList *productList = [[FUProductList alloc] initWithDictionary:json error:&error];

        [self.products addObjectsFromArray:productList.products];

        self.foundRows = productList.totalCount;

        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:FUProductManagerDidFinishLoadingPageNotification object:nil];
        }
        
        self.isLoading = NO;
    }];
}

@end
