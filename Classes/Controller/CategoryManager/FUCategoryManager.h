//
//  FUCategoryManager.h
//  furn
//
//  Created by Markus Bösch on 15/04/15.
//
//

#import <Foundation/Foundation.h>

extern NSString *const FUCategoryManagerDidFinishLoadingCategories;

@class FUCategoryList;

@interface FUCategoryManager : NSObject

@property (strong, nonatomic, readonly) FUCategoryList *categoryList;

@property (assign, nonatomic, readonly) BOOL isLoading;

+ (void)setup;

+ (instancetype)sharedManager;

@end
