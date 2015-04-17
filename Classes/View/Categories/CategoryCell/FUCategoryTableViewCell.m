//
//  FUCategoryTableViewCell.m
//  furn
//
//  Created by Markus Bösch on 15/04/15.
//
//

#import "FUCategoryTableViewCell.h"

#import "FUCategory.h"

NSString *const FUCategoryTableViewCellReuseIdentifier = @"FUCategoryTableViewCellReuseIdentifier";

@interface FUCategoryTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UIImageView *categoryAccessoryView;

@end

@implementation FUCategoryTableViewCell

#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.categoryAccessoryView.transform = CGAffineTransformMakeRotation(M_PI);
}


#pragma mark - Setter

- (void)setCategory:(FUCategory *)category
{
    _category = category;
    
    if (category) {
        if (self.isAllProductsCell) {
            self.categoryLabel.text = [[NSString stringWithFormat:@"SHOW ALL %@", category.name] uppercaseString];
            
            self.categoryAccessoryView.hidden = NO;
        } else {
            self.categoryLabel.text = category.name.uppercaseString;
    
            self.categoryAccessoryView.hidden = !category.hasChildren;
        }
    }
}

- (void)setIsAllProductsCell:(BOOL)isAllProductsCell
{
    if (_isAllProductsCell == isAllProductsCell) {
        return;
    }
    
    _isAllProductsCell = isAllProductsCell;
    
    // TODO: Need asset to show double arrow
}

#pragma mark - Static

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

@end
