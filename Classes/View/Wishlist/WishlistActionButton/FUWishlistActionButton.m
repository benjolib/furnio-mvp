//
//  FUWishlistActionButton.m
//  furn
//
//  Created by Markus Bösch on 10/04/15.
//
//

#import "FUWishlistActionButton.h"

@implementation FUWishlistActionButton

#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupLayer];
    
    self.highlighted = NO;
}

#pragma mark - Setter

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.tintColor = [UIColor whiteColor];
        self.backgroundColor = self.normalTintColor;
    } else {
        self.tintColor = self.normalTintColor;
        self.backgroundColor = self.normalBackgroundColor;
    }
}

- (void)setNormalTintColor:(UIColor *)normalTintColor
{
    _normalTintColor = normalTintColor;
    
    [self setupLayer];
}

#pragma mark - Private

- (void)setupLayer
{
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.borderWidth = 1.5f;
    self.layer.borderColor = self.normalTintColor.CGColor;
}

@end
