//
//  FUCategoryManager.h
//  furn
//
//  Created by Markus Bösch on 15/04/15.
//
//

#import <Foundation/Foundation.h>

extern NSString *const FUCategoryManagerDidFinishLoadingCategories;

@class FUCategory;
@class FUCategoryList;

@interface FUCategoryManager : NSObject

@property (strong, nonatomic, readonly) FUCategoryList *categoryList;

@property (assign, nonatomic, readonly) BOOL isLoading;

@property (strong, nonatomic, readonly) NSArray *categoryNames;

+ (void)setup;

+ (instancetype)sharedManager;

- (void)registerCategory:(FUCategory *)category;

- (NSArray *)categoryNamesMatchingSearchQuery:(NSString *)searchQuery;

- (FUCategory *)categoryForName:(NSString *)categoryName;


@end
