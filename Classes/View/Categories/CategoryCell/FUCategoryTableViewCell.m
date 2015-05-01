//
//  FUCategoryTableViewCell.m
//  furn
//
//  Created by Markus Bösch on 15/04/15.
//
//

#import "FUCategoryTableViewCell.h"

#import "FUCategory.h"
#import "FUColorConstants.h"

NSString *const FUCategoryTableViewCellReuseIdentifier = @"FUCategoryTableViewCellReuseIdentifier";

static CGFloat const FUCategoryTableViewCellAccessoryViewDefaultTrailingSpace = 8;

@interface FUCategoryTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UIImageView *categoryAccessoryView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryAccessoryViewTrailingSpaceConstraint;


@end

@implementation FUCategoryTableViewCell

#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [FUColorOrange colorWithAlphaComponent:0];

    self.categoryAccessoryView.transform = CGAffineTransformMakeRotation(M_PI);
}


#pragma mark - Setter

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [UIView animateWithDuration:0.35f animations:^{
        CGFloat alpha = highlighted ? 0.5f : 0;

        self.backgroundColor = [FUColorOrange colorWithAlphaComponent:alpha];
    }];
}

- (void)setCategory:(FUCategory *)category
{
    _category = category;
    
    if (category) {
        if (self.isAllProductsCell) {
            self.categoryLabel.text = [NSString stringWithFormat:@"Show All %@", category.name];
            
            self.categoryAccessoryView.hidden = NO;
        } else {
            self.categoryLabel.text = category.name;
    
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
    
    if (isAllProductsCell) {
        self.categoryAccessoryView.image = [UIImage imageNamed:@"double-arrow"];
        self.categoryAccessoryView.transform = CGAffineTransformIdentity;
        self.categoryAccessoryViewTrailingSpaceConstraint.constant = FUCategoryTableViewCellAccessoryViewDefaultTrailingSpace + 3;
    } else {
        self.categoryAccessoryView.image = [UIImage imageNamed:@"back"];
        self.categoryAccessoryView.transform = CGAffineTransformMakeRotation(M_PI);
        self.categoryAccessoryViewTrailingSpaceConstraint.constant = FUCategoryTableViewCellAccessoryViewDefaultTrailingSpace;
    }
}

#pragma mark - Static

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

@end
