//
//  FULoadingView.m
//  furn
//
//  Created by Markus Bösch on 17/04/15.
//
//

#import "FULoadingView.h"

#import "FUColorConstants.h"

@implementation FULoadingView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    
    if (self) {
        self.frame = frame;
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.loadingLabel.textColor = FUColorOrange;
    self.activityIndicator.color = FUColorOrange;

    self.loadingLabel.alpha = 0;
    self.activityIndicator.alpha = 0;
}

- (void)showAnimated:(BOOL)animated
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    [self updateSubViewsAnimated:animated hidden:NO];
}

- (void)hideAnimated:(BOOL)animated
{
    [self updateSubViewsAnimated:animated hidden:YES];
}

- (void)updateSubViewsAnimated:(BOOL)animated hidden:(BOOL)hidden
{
    CGFloat duration = animated ? 0.25f : 0;
    
    [UIView animateWithDuration:duration animations:^{
        self.loadingLabel.alpha = !hidden;
        self.activityIndicator.alpha = !hidden;
    } completion:^(BOOL finished) {
        if (hidden) {
            [self removeFromSuperview];
        }
    }];
}

@end
