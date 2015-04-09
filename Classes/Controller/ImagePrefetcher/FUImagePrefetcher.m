//
//  FUImagePrefetcher.m
//  furn
//
//  Created by Markus Bösch on 09/04/15.
//
//

#import "FUImagePrefetcher.h"
#import "FUProduct.h"
#import "FUProductManager.h"

#import <SDWebImagePrefetcher.h>


@implementation FUImagePrefetcher

#pragma mark - Initialization

+ (instancetype)sharedPrefetcher
{
    static FUImagePrefetcher *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [FUImagePrefetcher new];
    });
    
    return instance;
}

#pragma mark - Prefetching

- (void)prefetchImagesWithURLs:(NSArray *)urls
{
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:urls];
}

- (void)prefetchImageForProduct:(FUProduct *)product
{
    if (!product.catalogImageURL) {
        return;
    }

    [self prefetchImagesWithURLs:@[ product.catalogImageURL ]];
}

- (void)prefetchImagesForProducts:(NSArray *)products
{
    NSArray *urls = [products valueForKey:@"catalogImageURL"];
    
    [self prefetchImagesWithURLs:urls];
}

- (void)prefetchImagesForProductsAroundIndex:(NSInteger)index
{
    static NSInteger const prefetchCount = 8;
    
    if (index % prefetchCount > 0 && index + prefetchCount < [FUProductManager sharedManager].productCount) {
        return;
    }

    NSMutableArray *products = [NSMutableArray array];
    
    for (NSUInteger i = index; i < (index + prefetchCount) && i < [FUProductManager sharedManager].productCount; i++) {
        FUProduct *product = [[FUProductManager sharedManager] productAtIndex:i];
        
        if (product) {
            [products addObject:product];
        }
    }
    
    [self prefetchImagesForProducts:products];
}

@end
