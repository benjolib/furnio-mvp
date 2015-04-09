//
//  FUProductManager.m
//  furn
//
//  Created by Markus Bösch on 08/04/15.
//
//

#import "FUProductManager.h"

#import "FUProductList.h"

#import <JSONHTTPClient.h>

static NSUInteger const FUProductManagerRowLimit = 20;


@interface FUProductManager ()

@property (strong, nonatomic) FUProductList *productList;

@end


@implementation FUProductManager

#pragma mark - Initialization

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
    
    if (productLimit < self.productList.products.count) {
        return [self.productList.products subarrayWithRange:NSMakeRange(productStart, FUProductManagerRowLimit)];
    }
    
    return nil;
}

- (FUProduct *)productAtIndex:(NSInteger)index
{
    if (index < self.productList.products.count) {
        return [self.productList.products objectAtIndex:index];
    }

    return nil;
}

- (FUProduct *)productForColumnAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [self absoluteIndexForIndexPath:indexPath];
    
    if (index < self.productList.products.count) {
        return [self.productList.products objectAtIndex:index];
    }
    
    return nil;
}

- (NSInteger)productCount
{
    return self.productList.products.count;
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

#pragma mark - Private

- (void)loadProducts
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"productList" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSError *error;
    self.productList = [[FUProductList alloc] initWithData:data error:&error];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
}

@end
