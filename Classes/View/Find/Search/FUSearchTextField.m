//
//  FUSearchTextField.m
//  furn
//
//  Created by Markus Bösch on 19/04/15.
//
//

#import "FUSearchTextField.h"

#import "FUColorConstants.h"

@implementation FUSearchTextField

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        [self setupLayerBorder];
    }
    
    return self;
}

#pragma mark - UITextField

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(15, bounds.origin.y, bounds.size.width - 45, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(15, bounds.origin.y, bounds.size.width - 45, bounds.size.height);
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    CGRect originalRect = [super clearButtonRectForBounds:bounds];

    return CGRectOffset(originalRect, -2, 0);
}

#pragma mark - Private

- (void)setupLayerBorder
{
    self.layer.borderColor = FUColorLightGray.CGColor;
    self.layer.borderWidth = 1;
}

@end
