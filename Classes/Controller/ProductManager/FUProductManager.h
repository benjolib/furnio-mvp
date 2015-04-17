//
//  FUProductManager.h
//  furn
//
//  Created by Markus Bösch on 08/04/15.
//
//

#import <Foundation/Foundation.h>

@class FUProductList;
@class FUProduct;
@class FUCategory;

extern NSString *const FUProductManagerDidFinishLoadingPageNotification;

@interface FUProductManager : NSObject

@property (strong, nonatomic) FUCategory *category;

+ (void)setup;

+ (instancetype)sharedManager;

- (FUProduct *)productAtIndex:(NSInteger)index;

- (NSArray *)productsForColumnAtIndex:(NSInteger)index;

- (FUProduct *)productForColumnAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)absoluteIndexForIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)absoluteIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)productCount;

- (NSInteger)columnCount;

- (void)reset;

@end
