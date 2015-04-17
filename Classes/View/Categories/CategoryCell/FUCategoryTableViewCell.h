//
//  FUCategoryTableViewCell.h
//  furn
//
//  Created by Markus Bösch on 15/04/15.
//
//

#import <UIKit/UIKit.h>

@class FUCategory;

extern NSString *const FUCategoryTableViewCellReuseIdentifier;

@interface FUCategoryTableViewCell : UITableViewCell

@property (strong, nonatomic) FUCategory *category;

@property (assign, nonatomic) BOOL isAllProductsCell;

+ (UINib *)nib;

@end
