//
//  FUWishlistEmptyCollectionViewCell.m
//  furn
//
//  Created by Markus Bösch on 10/04/15.
//
//

#import "FUWishlistEmptyCollectionViewCell.h"

#import "FUActionButton.h"

NSString *const FUWishlistEmptyCollectionViewCellReuseIdentifier = @"FUWishlistEmptyCollectionViewCellReuseIdentifier";

@interface FUWishlistEmptyCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *emptyImageView;

@property (weak, nonatomic) IBOutlet FUActionButton *startSwipingButton;

@end


@implementation FUWishlistEmptyCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.emptyImageView.image = [[UIImage imageNamed:@"empty"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
}


#pragma mark - Actions

- (IBAction)startSwipingProductsButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPressStartSwipingButton)]) {
        [self.delegate didPressStartSwipingButton];
    }
}

#pragma mark - Static

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

@end
