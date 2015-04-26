//
//  FULoadingView.m
//  furn
//
//  Created by Markus Bösch on 17/04/15.
//
//

#import "FULoadingView.h"

#import "FUColorConstants.h"

static CGFloat const FULoadingViewDelayInterval = 0.25f;

@interface FULoadingView ()

@property (strong, nonatomic) NSTimer *timer;

@end

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
    self.activityIndicatorView.tintColor = FUColorOrange;

    self.loadingLabel.alpha = 0;
    self.activityIndicatorView.alpha = 0;
}

- (void)showAnimated:(BOOL)animated
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    NSDictionary *userInfo = @{ @"animated" : @(animated) };

    self.timer = [NSTimer scheduledTimerWithTimeInterval:FULoadingViewDelayInterval target:self selector:@selector(showDelayed:) userInfo:userInfo repeats:NO];
}

- (void)showDelayed:(NSTimer *)timer
{
    BOOL animated = [[timer.userInfo objectForKey:@"animated"] boolValue];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self updateSubViewsAnimated:animated hidden:NO];
}

- (void)hideAnimated:(BOOL)animated
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }

    [self updateSubViewsAnimated:animated hidden:YES];
}

- (void)updateSubViewsAnimated:(BOOL)animated hidden:(BOOL)hidden
{
    CGFloat duration = animated ? 0.25f : 0;
    
    if (!hidden) {
        [self.activityIndicatorView startAnimating];
    }

    [UIView animateWithDuration:duration animations:^{
        self.loadingLabel.alpha = !hidden;
        self.activityIndicatorView.alpha = !hidden;
    } completion:^(BOOL finished) {
        if (hidden) {
            [self.activityIndicatorView stopAnimating];

            [self removeFromSuperview];
        }
    }];
}

@end
