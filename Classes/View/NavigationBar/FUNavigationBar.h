//
//  FUNavigationBar.h
//  furn
//
//  Created by Markus Bösch on 13/04/15.
//
//

#import <UIKit/UIKit.h>

extern const CGFloat FUNavigationBarDefaultOriginY;
extern const CGFloat FUNavigationBarDefaultHeight;

extern const CGFloat FUNavigationBarButtonMarginX;
extern const CGFloat FUNavigationBarButtonDimension;

typedef NS_ENUM(NSInteger, FUNavigationBarButtonPosition)
{
    FUNavigationBarButtonPositionLeft,
    FUNavigationBarButtonPositionRight
};

@interface FUNavigationBar : UIView

@property (strong, nonatomic) UIButton *leftButton;

@property (strong, nonatomic) UIButton *rightButton;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (assign, nonatomic) CGFloat originY;

@property (assign, nonatomic) CGFloat height;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController title:(NSString *)title originY:(CGFloat)originY height:(CGFloat)height;

- (UIButton *)newButtonWithImage:(UIImage *)image target:(id)target selector:(SEL)selector position:(FUNavigationBarButtonPosition)position;

- (UIButton *)newRoundedYellowButtonWithImage:(UIImage *)image target:(id)target selector:(SEL)selector position:(FUNavigationBarButtonPosition)position;

- (UIButton *)newBackButton;

@end
