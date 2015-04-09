//
//  FUImagePrefetcher.h
//  furn
//
//  Created by Markus Bösch on 09/04/15.
//
//

#import <Foundation/Foundation.h>

@class FUProduct;

@interface FUImagePrefetcher : NSObject

+ (instancetype)sharedPrefetcher;

- (void)prefetchImagesWithURLs:(NSArray *)urls;

- (void)prefetchImageForProduct:(FUProduct *)product;

- (void)prefetchImagesForProducts:(NSArray *)products;

- (void)prefetchImagesForProductsAroundIndex:(NSInteger)index;

@end
