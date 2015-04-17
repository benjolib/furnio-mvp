//
//  FUWishlistManager.h
//  furn
//
//  Created by Markus Bösch on 10/04/15.
//
//

#import <Foundation/Foundation.h>

@class FUProduct;


@interface FUWishlistManager : NSObject

@property (strong, nonatomic, readonly) NSMutableArray *products;

+ (instancetype)sharedManager;

- (void)addProduct:(FUProduct *)product;

- (void)removeAllProducts;

- (void)removeProduct:(FUProduct *)product;

- (void)removeProductAtIndex:(NSUInteger)index;

- (void)removeProductsAtIndexes:(NSIndexSet *)indexes;

@end
