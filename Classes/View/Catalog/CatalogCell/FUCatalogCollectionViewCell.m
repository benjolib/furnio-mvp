//
//  FUCatalogCollectionViewCell.m
//  furn
//
//  Created by Markus Bösch on 29/03/15.
//
//

#import "FUCatalogCollectionViewCell.h"

#import "FUProduct.h"
#import "FUNumberFormatter.h"
#import "FUColorConstants.h"

#import <UIImageView+WebCache.h>

NSString *const FUCatalogCollectionViewCellReuseIdentifier = @"FUCatalogCollectionViewCellReuseIdentifier";

static CGFloat const FUCatalogCellShadowAnimationDuration = 0.25f;


@interface FUCatalogCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewRatioConstraint;

@end


@implementation FUCatalogCollectionViewCell

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(FUCatalogCellShadowAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
                    self.imageView.alpha = 1;
                }];
            }
        }];
    }
    
    self.nameLabel.text = product.name;
    
    self.priceLabel.text = [[FUNumberFormatter currencyNumberFormatter] stringFromNumber:product.price];
}

- (void)setViewMode:(FUCollectionViewMode)viewMode
{
    _viewMode = viewMode;

    [self updateImageViewRatioConstraintWithViewMode:viewMode];

    self.nameLabel.hidden = (viewMode == FUCollectionViewModeMatrix);
    self.priceLabel.hidden = (viewMode == FUCollectionViewModeMatrix);
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
    CGFloat duration = animated ? FUCatalogCellShadowAnimationDuration : 0;
    
    [UIView animateWithDuration:duration animations:^{
        CGFloat scale = self.viewMode == FUCollectionViewModeMatrix ? 1.05f : 1.10f;

        self.imageView.transform = CGAffineTransformMakeScale(scale, scale);
    }];
}

- (void)hideTransformationAnimated:(BOOL)animated
{
    CGFloat duration = animated ? FUCatalogCellShadowAnimationDuration : 0;
    
    [UIView animateWithDuration:duration animations:^{
        self.imageView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - Private

- (void)updateImageViewRatioConstraintWithViewMode:(FUCollectionViewMode)viewMode
{
    CGFloat multiplier;
    CGFloat constant;

    if (viewMode == FUCollectionViewModeMatrix) {
        multiplier = self.frame.size.width / self.frame.size.height;
        constant = 0;
    } else {
        multiplier = 1;
        
        constant = [UIScreen mainScreen].bounds.size.height > 568 ? 15 : -10;
    }
    
    if (self.imageViewRatioConstraint) {
        [self.imageView removeConstraint:self.imageViewRatioConstraint];
    }

    self.imageViewRatioConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeHeight multiplier:multiplier constant:constant];
    
    [self.imageView addConstraint:self.imageViewRatioConstraint];
}

@end
