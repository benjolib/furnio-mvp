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
    self.backgroundColor = highlighted ? FUColorOrange : [UIColor whiteColor];
    
    self.titleLabel.textColor = highlighted ? [UIColor whiteColor] : FUColorOrange;
}

#pragma mark - Private

- (void)setupButton
{
    self.titleLabel.font = FUFontButtonTitle;
    
    self.layer.borderColor = FUColorOrange.CGColor;
    self.layer.borderWidth = 1.5f;
    
    self.highlighted = NO;
    
    self.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    [self setTitleColor:FUColorOrange forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

@end
