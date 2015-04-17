//
//  FUCategoriesViewController.h
//  furn
//
//  Created by Markus Bösch on 13/04/15.
//
//

#import "FUViewController.h"

@class FUCategory;

@interface FUCategoriesViewController : FUViewController

- (instancetype)initWithCategories:(NSArray *)categories;

- (instancetype)initWithCategories:(NSArray *)categories selectedCategory:(FUCategory *)category;

@end
