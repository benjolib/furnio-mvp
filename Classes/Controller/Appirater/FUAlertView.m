//
//  FUAlertView.m
//  furn
//
//  Created by Markus Bösch on 01/05/15.
//

#import "FUAlertView.h"

#import "FUActionButton.h"
#import "FUColorConstants.h"
#import "FUFontConstants.h"
#import "UIView+Framing.h"
#import "FULoadingViewManager.h"

#import <FXBlurView.h>


@interface FUAlertView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) FUActionButton *confirmButton;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) FXBlurView *blurView;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIButton *closeButton;

@end


static CGFloat const FUAlertViewPadding = 20;
static CGFloat const FUAlertViewContainerPadding = 60;

@implementation FUAlertView

@dynamic delegate;

#pragma mark - Initialization

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
           confirmButtonTitle:(NSString *)confirmButtonTitle
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];

    if (self) {
        self.delegate = delegate;
        
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        self.blurView = [[FXBlurView alloc] initWithFrame:self.frame];
        self.blurView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.blurView.blurRadius = 40.0f;
        
        [self addSubview:self.blurView];
        
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(FUAlertViewPadding, 0.0f, self.blurView.width - 2 * FUAlertViewPadding, self.height)];
        self.containerView.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.85f];
        
        self.containerView.layer.borderWidth = 1.0f;
        self.containerView.layer.borderColor = FUColorLightGray.CGColor;
        self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        [self.blurView addSubview:self.containerView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FUAlertViewContainerPadding, 0.0f, 0.0f, 0.0f)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = FUFontRateAppTitle;
        self.titleLabel.textColor = FUColorDarkGray;
        self.titleLabel.numberOfLines = 0;
        
        [self.containerView addSubview:self.titleLabel];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(FUAlertViewContainerPadding, 0.0f, 0.0f, 0.0f)];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = FUFontRateAppMessage;
        self.textLabel.textColor = FUColorDarkGray;
        self.textLabel.numberOfLines = 0;
        
        [self.containerView addSubview:self.textLabel];
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        self.closeButton.frame = CGRectMake(0.0f, 0.0f, 68.0f, 68.0f);
        self.closeButton.imageEdgeInsets = UIEdgeInsetsMake(15.0f, 15.0f, 25.0f, 25.0f);

        [self.closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.containerView addSubview:self.closeButton];
        
        self.confirmButton = [[FUActionButton alloc] initWithFrame:CGRectMake(FUAlertViewPadding, 0.0f, self.containerView.width - 2 * FUAlertViewPadding, 60.0f)];

        [self.containerView addSubview:self.confirmButton];
        
        [self.confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.cancelButton.frame = CGRectMake(FUAlertViewPadding, 0.0f, self.containerView.width - 2 * FUAlertViewPadding, 60.0f);

        [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.cancelButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = FUFontRateAppCancel;
        [self.cancelButton setTitleColor:FUColorDarkGray forState:UIControlStateNormal];

        [self.containerView addSubview:self.cancelButton];
        
        self.titleLabel.text = title;
        self.textLabel.text = message;
        [self.confirmButton setTitle:confirmButtonTitle forState:UIControlStateNormal];
        [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        
        [self layoutSubviews];
    }
    
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    
    self.titleLabel.width = self.containerView.width - 2 * FUAlertViewContainerPadding;

    [self.textLabel sizeToFit];
    
    self.textLabel.width = self.containerView.frame.size.width - 2 * FUAlertViewContainerPadding;
    
    CGFloat totalHeight = self.titleLabel.height + 15.0f + self.textLabel.height + 25.0f + self.confirmButton.height + 8.0f + self.cancelButton.height;
    
    self.titleLabel.top = 70.0f;
    
    self.textLabel.top = self.titleLabel.bottom + 8.0f;
    
    self.confirmButton.top = self.textLabel.bottom + 35.0f;
    
    self.cancelButton.top = self.confirmButton.bottom + 8.0f;
    
    self.containerView.height = 55.0f + totalHeight + 30.0f;
    
    CGFloat y = (self.height - self.containerView.height) / 2;
    
    self.containerView.top = y;
}

#pragma mark - Action

- (void)closeButtonPressed:(UIButton *)button
{
    [self hide:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewClose:)]) {
        [self.delegate alertViewClose:self];
    }
}

- (void)confirmButtonPressed:(UIButton *)button
{
    [self hide:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewConfirm:)]) {
        [self.delegate alertViewConfirm:self];
    }
}

- (void)cancelButtonPressed:(UIButton *)button
{
    [self hide:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewCancel:)]) {
        [self.delegate alertViewCancel:self];
    }
}

#pragma mark - Public

- (void)show:(BOOL)animated
{
    [FULoadingViewManager sharedManger].allowLoadingView = NO;

    self.alpha = 0.0f;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    window.windowLevel = UIWindowLevelStatusBar + 1;
    
    self.blurView.underlyingView = window;
    
    [window addSubview:self];
    
    if (animated) {
        [UIView animateWithDuration:0.5f delay:0.01f options:0 animations:^{
            self.alpha = 1.0f;
        } completion:nil];
    }
    else {
        self.alpha = 1.0f;
    }
}

- (void)hide:(BOOL)animated
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    CGFloat duration = animated ? 0.5f : 0;

    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        window.windowLevel = UIWindowLevelNormal;

        [FULoadingViewManager sharedManger].allowLoadingView = YES;
    }];
}

@end
