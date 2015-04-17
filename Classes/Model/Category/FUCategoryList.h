//
//  FUCategoryList.h
//  furn
//
//  Created by Markus Bösch on 15/04/15.
//
//

#import "JSONModel.h"

#import "FUCategory.h"

@interface FUCategoryList : JSONModel

@property (strong, nonatomic) NSArray<FUCategory> *categories;

@end
