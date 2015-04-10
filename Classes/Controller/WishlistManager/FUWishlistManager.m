//
//  FUWishlistManager.m
//  furn
//
//  Created by Markus Bösch on 10/04/15.
//
//

#import "FUWishlistManager.h"

#import "FUProductManager.h"

@interface FUWishlistManager ()

@property (strong, nonatomic) NSMutableArray *products;

@end

@implementation FUWishlistManager

#pragma mark - Initialization

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)sharedManager
{
    static FUWishlistManager *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [FUWishlistManager new];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.products = [[[FUProductManager sharedManager] productsForColumnAtIndex:0] mutableCopy];
    }

    return self;
}

- (void)addProduct:(FUProduct *)product
{
    if (![self.products containsObject:product]) {
        [self.products addObject:product];
    }
}

- (void)removeAllProducts
{
    [self.products removeAllObjects];
}

- (void)removeProduct:(FUProduct *)product
{
    [self.products removeObject:product];
}

- (void)removeProductAtIndex:(NSUInteger)index
{
    if (index < self.products.count) {
        [self.products removeObjectAtIndex:index];
    }
}

@end
