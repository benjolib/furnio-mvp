//
//  FUWishlistCollectionViewCell.m
//  furn
//
//  Created by Markus Bösch on 10/04/15.
//
//

#import "FUWishlistCollectionViewCell.h"
#import "FUProduct.h"
#import "FUNumberFormatter.h"
#import "FUColorConstants.h"
#import "FUWishlistActionButton.h"

#import <UIImageView+WebCache.h>


NSString *const FUWishlistCollectionViewCellReuseIdentifier = @"FUWishlistCollectionViewCellReuseIdentifier";

static CGFloat const FUWishlistCollectionViewCellImageViewReducedAlpha = 0.1f;
static CGFloat const FUWishlistCellShadowAnimationDuration = 0.25f;


@interface FUWishlistCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewContainerRatioConstraint;


@end

@implementation FUWishlistCollectionViewCell

#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.deleteButton.normalTintColor = FUColorDarkGray;
    self.deleteButton.normalBackgroundColor = [UIColor clearColor];

    self.shareButton.normalTintColor = FUColorOrange;
    self.shareButton.normalBackgroundColor = [UIColor clearColor];
    
    self.imageViewContainerRatioConstraint.constant = [UIScreen mainScreen].bounds.size.height > 568 ? 15 : -10;
}


#pragma mark - Setter

- (void)setHighlighted:(BOOL)highlighted
{
    [self toggleAnimationEnabled:highlighted];
}

- (void)setSelected:(BOOL)selected
{
    [self toggleAnimationEnabled:selected hideDelay:0];
    
    if (selected) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(FUWishlistCellShadowAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideTransformationAnimated:YES];
        });
    }
}

- (void)setProduct:(FUProduct *)product
{
    _product = product;
    
    self.imageView.alpha = 0;
    
    if (product.catalogImageURL) {
        [self.imageView sd_setImageWithURL:product.catalogImageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                CGFloat duration = cacheType == SDImageCacheTypeNone ? 0.25f : 0;
                [UIView animateWithDuration:duration animations:^{
                    self.imageView.alpha = self.viewState == FUWishlistViewStateNormal ? 1 : FUWishlistCollectionViewCellImageViewReducedAlpha;
                }];
            }
        }];
    }
    
    self.nameLabel.text = product.name;
    
    self.priceLabel.text = [[FUNumberFormatter currencyNumberFormatter] stringFromNumber:product.price];
}

- (void)setViewState:(FUWishlistViewState)viewState
{
    _viewState = viewState;
    
    self.imageView.alpha = viewState == FUWishlistViewStateNormal ? 1 : FUWishlistCollectionViewCellImageViewReducedAlpha;
    
    for (UIButton *button in @[self.deleteButton, self.shareButton]) {
        button.hidden = viewState == FUWishlistViewStateNormal;
    }
}

#pragma mark - Animation state

- (void)toggleAnimationEnabled:(BOOL)enabled
{
    [self toggleAnimationEnabled:enabled hideDelay:0.2f];
}

- (void)toggleAnimationEnabled:(BOOL)enabled hideDelay:(NSTimeInterval)hideDelay
{
    if (enabled) {
        [self showTransformationAnimated:YES];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideTransformationAnimated:YES];
        });
    }
}

- (void)showTransformationAnimated:(BOOL)animated
{
    CGFloat duration = animated ? FUWishlistCellShadowAnimationDuration : 0;
    
    [UIView animateWithDuration:duration animations:^{
        CGFloat scale = 1.10f;

        self.imageView.transform = CGAffineTransformMakeScale(scale, scale);
    }];
}

- (void)hideTransformationAnimated:(BOOL)animated
{
    CGFloat duration = animated ? FUWishlistCellShadowAnimationDuration : 0;
    
    [UIView animateWithDuration:duration animations:^{
        self.imageView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - Actions

- (IBAction)deleteButtonTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;

    if (self.delegate && [self.delegate respondsToSelector:@selector(wishlistCollectionViewCell:didTapDeleteButtonWithProduct:isSelected:)]) {
        [self.delegate wishlistCollectionViewCell:self didTapDeleteButtonWithProduct:self.product isSelected:sender.selected];
    }
}

- (IBAction)shareButtonTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;

    if (self.delegate && [self.delegate respondsToSelector:@selector(wishlistCollectionViewCell:didTapShareButtonWithProduct:isSelected:)]) {
        [self.delegate wishlistCollectionViewCell:self didTapShareButtonWithProduct:self.product isSelected:sender.selected];
    }
}

#pragma mark - Static

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

@end
