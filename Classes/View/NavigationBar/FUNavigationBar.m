//
//  FUNavigationBar.m
//  furn
//
//  Created by Markus Bösch on 13/04/15.
//
//

#import "FUNavigationBar.h"

#import "UIView+FUAnimations.h"
#import "FUFontConstants.h"
#import "FUColorConstants.h"
#import "UIControl+HitTest.h"

const CGFloat FUNavigationBarDefaultOriginY = 25;
const CGFloat FUNavigationBarDefaultHeight = 25;

const CGFloat FUNavigationBarButtonMarginX = 15;
const CGFloat FUNavigationBarBackButtonMarginX = 9;
const CGFloat FUNavigationBarButtonDimension = FUNavigationBarDefaultHeight;

static const CGFloat FUNavigationBarButtonHitMargin = 5;

@implementation FUNavigationBar

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    return [self initWithNavigationController:navigationController title:nil originY:FUNavigationBarDefaultOriginY height:FUNavigationBarDefaultHeight];
}

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController title:(NSString *)title originY:(CGFloat)originY height:(CGFloat)height
{
    NSParameterAssert(navigationController);
    
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, originY + height);

    self = [super initWithFrame:frame];
    
    if (self) {
        self.navigationController = navigationController;
        self.title = title;
        self.originY = originY;
    
        [self setupTitleLabel];
        
        self.leftButton = [self newCloseButton];
    }

    return self;
}

#pragma mark - Setter

- (void)setLeftButton:(UIButton *)leftButton
{
    if (_leftButton) {
        [_leftButton removeFromSuperview];
        
        _leftButton = nil;
    }

    if (leftButton) {
        leftButton.hitTestEdgeInsets = UIEdgeInsetsMake(-leftButton.frame.origin.y, -leftButton.frame.origin.x, -FUNavigationBarButtonHitMargin, -FUNavigationBarButtonHitMargin);

        _leftButton = leftButton;
        
        [self addSubview:_leftButton];
    }
}

- (void)setRightButton:(UIButton *)rightButton
{
    if (_rightButton) {
        [_rightButton removeFromSuperview];
        
        _rightButton = nil;
    }
    
    if (rightButton) {
        CGFloat inset = [UIScreen mainScreen].bounds.size.width - rightButton.frame.origin.x - rightButton.frame.size.width;
        rightButton.hitTestEdgeInsets = UIEdgeInsetsMake(-rightButton.frame.origin.y, -FUNavigationBarButtonHitMargin, -FUNavigationBarButtonHitMargin, -inset);

        _rightButton = rightButton;
        
        [self addSubview:_rightButton];
    }
}

- (void)setTitle:(NSString *)title
{
    _title = [title uppercaseString];

    self.titleLabel.text = title;
}

- (void)setOriginY:(CGFloat)originY
{
    _originY = originY;

    self.frame = CGRectMake(0, 0, self.frame.size.width, originY + self.frame.size.height);
}

- (void)setHeight:(CGFloat)height
{
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.originY + height + FUNavigationBarButtonHitMargin);
}

#pragma mark - Actions

- (void)closeButtonTapped:(UIButton *)sender
{
    [sender animateScaling];

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)backButtonTapped:(UIButton *)sender
{
    [sender animateScaling];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Buttons

- (UIButton *)newRoundedYellowButtonWithImage:(UIImage *)image target:(id)target selector:(SEL)selector position:(FUNavigationBarButtonPosition)position
{
    UIButton *button = [UIButton new];
    
    [button setImage:image forState:UIControlStateNormal];
    
    CGFloat dimension = FUNavigationBarButtonDimension * 2;

    CGFloat originX = position == FUNavigationBarButtonPositionLeft ? FUNavigationBarButtonMarginX : [UIScreen mainScreen].bounds.size.width - dimension - FUNavigationBarButtonMarginX;
    
    button.frame = CGRectMake(originX, [self originY], dimension, dimension);
    button.backgroundColor = FUColorOrange;
    button.layer.cornerRadius = button.frame.size.width / 2;
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];

    return button;
}

- (UIButton *)newButtonWithImage:(UIImage *)image target:(id)target selector:(SEL)selector position:(FUNavigationBarButtonPosition)position
{
    UIButton *button = [UIButton new];
    
    [button setImage:image forState:UIControlStateNormal];

    CGFloat originX = position == FUNavigationBarButtonPositionLeft ? FUNavigationBarButtonMarginX : [UIScreen mainScreen].bounds.size.width - FUNavigationBarButtonDimension - FUNavigationBarButtonMarginX;
    
    button.frame = CGRectMake(originX, [self originY], FUNavigationBarButtonDimension, FUNavigationBarButtonDimension);
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIButton *)newBackButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    button.frame = CGRectMake(FUNavigationBarBackButtonMarginX, [self originY], FUNavigationBarButtonDimension, FUNavigationBarButtonDimension);
    
    [button addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

- (UIButton *)newCloseButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    
    button.frame = CGRectMake(FUNavigationBarButtonMarginX, [self originY], FUNavigationBarButtonDimension, FUNavigationBarButtonDimension);

    [button addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - Private

- (void)setupTitleLabel
{
    if (self.titleLabel) {
        [self.titleLabel removeFromSuperview];
        self.titleLabel = nil;
    }

    CGFloat margin = FUNavigationBarBackButtonMarginX + FUNavigationBarButtonDimension + 10;

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, self.frame.size.width - (2 * margin), self.frame.size.height)];

    self.titleLabel.text = self.title;
    self.titleLabel.font = FUFontNavigationTitle;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = FUColorDarkGray;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;

    [self addSubview:self.titleLabel];
}

@end
