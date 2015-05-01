//
//  FUSearchTableViewCell.m
//  furn
//
//  Created by Markus Bösch on 01/05/15.
//
//

#import "FUSearchTableViewCell.h"

#import "FUColorConstants.h"

NSString *const FUSearchTableViewCellReuseIdentifier = @"FUSearchTableViewCellReuseIdentifier";


@implementation FUSearchTableViewCell

#pragma mark - Initialization

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

#pragma mark - Setter

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [UIView animateWithDuration:0.35f animations:^{
        CGFloat alpha = highlighted ? 0.5f : 0;
        
        self.backgroundColor = [FUColorOrange colorWithAlphaComponent:alpha];
    }];
}

@end
