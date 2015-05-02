//
//  FUActionButton.m
//  furn
//
//  Created by Markus Bösch on 10/04/15.
//
//

#import "FUActionButton.h"

#import "FUFontConstants.h"
#import "FUColorConstants.h"

@implementation FUActionButton

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupButton];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupButton];
    }
    
    return self;
}

#pragma mark - Setter

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        if (self.useInvertedColors) {
            self.backgroundColor = [UIColor whiteColor];
            self.titleLabel.textColor = FUColorOrange;
        } else {
            self.backgroundColor = FUColorOrange;
            self.titleLabel.textColor = [UIColor whiteColor];
        }
    } else {
        if (self.useInvertedColors) {
            self.backgroundColor = FUColorOrange;
            self.titleLabel.textColor = [UIColor whiteColor];
        } else {
            self.backgroundColor = [UIColor whiteColor];
            self.titleLabel.textColor = FUColorOrange;
        }
    }    
}

- (void)setUseInvertedColors:(BOOL)useInvertedColors
{
    _useInvertedColors = useInvertedColors;
    
    UIColor *normalColor = self.useInvertedColors ? [UIColor whiteColor] : FUColorOrange;
    UIColor *highlightedColor = self.useInvertedColors ? FUColorOrange : [UIColor whiteColor];
    
    [self setTitleColor:normalColor forState:UIControlStateNormal];
    [self setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    
    self.backgroundColor = self.useInvertedColors ? FUColorOrange : [UIColor whiteColor];
    
    self.layer.borderColor = normalColor.CGColor;
}

#pragma mark - Private

- (void)setupButton
{
    self.titleLabel.font = FUFontButtonTitle;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.layer.borderColor = FUColorOrange.CGColor;
    self.layer.borderWidth = 1.5f;
    
    self.highlighted = NO;
    
    self.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    UIColor *normalColor = FUColorOrange;
    UIColor *highlightedColor = [UIColor whiteColor];

    [self setTitleColor:normalColor forState:UIControlStateNormal];
    [self setTitleColor:highlightedColor forState:UIControlStateHighlighted];
}

@end
