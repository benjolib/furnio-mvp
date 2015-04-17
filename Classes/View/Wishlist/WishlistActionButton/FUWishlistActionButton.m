//
//  FUWishlistActionButton.m
//  furn
//
//  Created by Markus Bösch on 10/04/15.
//
//

#import "FUWishlistActionButton.h"

@implementation FUWishlistActionButton

@synthesize selected = _selected;


#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupLayer];
    
    self.imageView.image = [self.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

#pragma mark - Setter

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.tintColor = [UIColor whiteColor];
        self.backgroundColor = self.normalTintColor;
    } else {
        if (!self.selected) {
            self.tintColor = self.normalTintColor;
            self.backgroundColor = self.normalBackgroundColor;
        }
    }
}

- (BOOL)isSelected
{
    return _selected;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;

    if (selected) {
        self.backgroundColor = self.normalTintColor;
        self.tintColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = self.normalBackgroundColor;
        self.tintColor = self.normalTintColor;
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
    
    self.tintColor = self.normalTintColor;
    self.backgroundColor = self.normalBackgroundColor;
}

@end
