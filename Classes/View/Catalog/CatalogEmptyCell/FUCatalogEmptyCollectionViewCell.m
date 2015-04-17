//
//  FUCatalogEmptyCollectionViewCell.m
//  furn
//
//  Created by Markus Bösch on 17/04/15.
//
//

#import "FUCatalogEmptyCollectionViewCell.h"

NSString *const FUCatalogEmptyCollectionViewCellReuseIdentifier = @"FUCatalogEmptyCollectionViewCellReuseIdentifier";

@interface FUCatalogEmptyCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *emptyImageView;

@end

@implementation FUCatalogEmptyCollectionViewCell


#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.emptyImageView.image = [[UIImage imageNamed:@"empty"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
}

#pragma mark - Actions

- (IBAction)resetButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapResetButton)]) {
        [self.delegate didTapResetButton];
    }
}

#pragma mark - Static

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

@end
