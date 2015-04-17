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


static NSUInteger const FUProductManagerRowLimit = 20;

static NSUInteger const FUProductManagerPageSize = 200;

NSString *const FUProductManagerDidFinishLoadingPageNotification = @"FUProductManagerDidFinishLoadingPageNotification";

@interface FUProductManager ()

@property (strong, nonatomic) NSMutableArray *products;

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

- (void)reset
{
    self.category = nil;
    
    self.foundRows = @0;

    [self loadProducts];
}

#pragma mark - Getter

- (NSUInteger)currentOffset
{
    return self.products.count;
}

#pragma mark - Setter

- (void)setCategory:(FUCategory *)category
{
    if (_category.identifier && category.identifier && [_category.identifier isEqualToNumber:category.identifier]) {
        return;
    }
    
    _category = category;
    
    [self.products removeAllObjects];

    [self loadProducts];
}

- (void)setFoundRows:(NSNumber *)foundRows
{
    _foundRows = foundRows;
    
    [FULoadingViewManager sharedManger].allowLoadingView = foundRows.integerValue == 0;
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
    
    [parameters setValue:@([self currentOffset]) forKey:@"start"];
    [parameters setValue:@(FUProductManagerPageSize) forKey:@"limit"];

    if (self.category) {
        [parameters setValue:self.category.identifier.stringValue forKey:@"category[]"];
    }

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
