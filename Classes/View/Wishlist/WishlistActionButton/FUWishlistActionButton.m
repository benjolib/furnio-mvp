//
//  FUWishlistActionButton.m
//  furn
//
//  Created by Markus Bösch on 10/04/15.
//
//

#import "FUWishlistActionButton.h"

@implementation FUWishlistActionButton

#pragma mark - Setter

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];

    if (highlighted) {
        self.backgroundColor = self.normalTintColor;
    } else {
        if (!self.selected) {
            self.backgroundColor = self.normalBackgroundColor;
        }
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.backgroundColor = selected ? self.normalTintColor : self.normalBackgroundColor;
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
