//
//  FUWishlistManager.m
//  furn
//
//  Created by Markus Bösch on 10/04/15.
//
//

#import "FUWishlistManager.h"

#import "FUProductManager.h"
#import "FUTrackingManager.h"

#import <UIKit/UIKit.h>

@interface FUWishlistManager ()

@property (strong, nonatomic) NSMutableArray *products;

@property (assign, nonatomic) BOOL isDirty;

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
        [self setupNotifications];
        
        [self loadProducts];
    }

    return self;
}

- (void)addProduct:(FUProduct *)product
{
    if (!product) {
        return;
    }

    if (![self.products containsObject:product]) {
        [self.products addObject:product];
        self.isDirty = YES;
    }
}

- (void)removeAllProducts
{
    for (FUProduct *product in self.products) {
        [[FUTrackingManager sharedManager] trackWishlistRemoveProduct:product];
    }

    [self.products removeAllObjects];
    self.isDirty = YES;
}

- (void)removeProduct:(FUProduct *)product
{
    if (!product) {
        return;
    }
    
    [[FUTrackingManager sharedManager] trackWishlistRemoveProduct:product];

    [self.products removeObject:product];
    self.isDirty = YES;
}

- (void)removeProductAtIndex:(NSUInteger)index
{
    if (index < self.products.count) {
        FUProduct *product = [self.products objectAtIndex:index];
        
        [[FUTrackingManager sharedManager] trackWishlistRemoveProduct:product];
        
        [self.products removeObjectAtIndex:index];

        self.isDirty = YES;
    }
}

- (void)removeProductsAtIndexes:(NSIndexSet *)indexes
{
    [self.products enumerateObjectsAtIndexes:indexes options:kNilOptions usingBlock:^(FUProduct *product, NSUInteger index, BOOL *stop) {
        [[FUTrackingManager sharedManager] trackWishlistRemoveProduct:product];
    }];
    
    [self.products removeObjectsAtIndexes:indexes];
    
    self.isDirty = YES;
}

#pragma mark - Private

- (void)loadProducts
{
    self.products = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForProducts]];
    
    if (!self.products) {
        self.products = [NSMutableArray array];
        
        self.isDirty = YES;
    }
}

#pragma mark - Notifications

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveProducts) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveProducts) name:UIApplicationWillTerminateNotification object:nil];
}

- (void)saveProducts
{
    if (!self.isDirty) {
        return;
    }
    
    BOOL success = [NSKeyedArchiver archiveRootObject:self.products toFile:[self pathForProducts]];
    
    if (success) {
        self.isDirty = NO;
    }
}

#pragma mark - Helper

- (NSString *)pathForProducts
{
    NSString *path;
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    if (documentsDirectory) {
        path = [documentsDirectory stringByAppendingPathComponent:@"wishlist.plist"];
    }
    
    return path;
}

@end
