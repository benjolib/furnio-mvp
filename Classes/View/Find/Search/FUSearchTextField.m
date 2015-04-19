//
//  FUSearchTextField.m
//  furn
//
//  Created by Markus Bösch on 19/04/15.
//
//

#import "FUSearchTextField.h"

@implementation FUSearchTextField

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(10, bounds.origin.y, bounds.size.width - 40, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(10, bounds.origin.y, bounds.size.width - 40, bounds.size.height);
}

@end
