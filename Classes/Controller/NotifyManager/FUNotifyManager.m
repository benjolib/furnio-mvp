//
//  FUNotifyManager.m
//  furn
//
//  Created by Markus Bösch on 09/04/15.
//
//


#import <UIKit/UIKit.h>
#import <AFNetworkReachabilityManager.h>

#import "FUNotifyManager.h"
#import "FUColorConstants.h"
#import "FUFontConstants.h"

static CGFloat const FUNotifyManagerMessageLabelHeight = 44;
static CGFloat const FUNotifyManagerMessageAnimationDuration = 0.35f;


@interface FUNotifyManager ()

@property (strong, nonatomic) UILabel *messageLabel;

@end


@implementation FUNotifyManager

#pragma mark - Initialization

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)setup
{
    [self sharedManager];
}

+ (instancetype)sharedManager
{
    static FUNotifyManager *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [FUNotifyManager new];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self setupNotifications];        
    }
    
    return self;
}

#pragma mark - Notifications

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    NSNumber *statusNumber = [notification.userInfo objectForKey:AFNetworkingReachabilityNotificationStatusItem];
    AFNetworkReachabilityStatus status = statusNumber.integerValue;
    
    if (status <= AFNetworkReachabilityStatusNotReachable) {
        [self showMessageWithText:@"NO CONNECTIVITY"];
    } else {
        [self hideMessage];
    }
}

- (void)showMessageWithText:(NSString *)text
{
    [self showMessageWithText:text backgroundColor:FUColorLightRed];
}

- (void)showMessageWithText:(NSString *)text backgroundColor:(UIColor *)backgroundColor
{
    if (self.messageLabel) {
        self.messageLabel.text = text;
    } else {
        self.messageLabel = [self newMessageLabelWithBackgroundColor:backgroundColor];
        self.messageLabel.text = text;

        [[[UIApplication sharedApplication] keyWindow] addSubview:self.messageLabel];
        
        [UIView animateWithDuration:FUNotifyManagerMessageAnimationDuration animations:^{
            CGRect frame = self.messageLabel.frame;
            frame.origin.y = 0;
            self.messageLabel.frame = frame;
        }];
    }
}

- (void)hideMessage
{
    if (self.messageLabel) {
        [UIView animateWithDuration:FUNotifyManagerMessageAnimationDuration animations:^{
            CGRect frame = self.messageLabel.frame;
            frame.origin.y = -FUNotifyManagerMessageLabelHeight;
            self.messageLabel.frame = frame;
        } completion:^(BOOL finished) {
            [self.messageLabel removeFromSuperview];
            
            self.messageLabel = nil;
        }];
    }
}

- (UILabel *)newMessageLabelWithBackgroundColor:(UIColor *)backgroundColor
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;

    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -FUNotifyManagerMessageLabelHeight, width, FUNotifyManagerMessageLabelHeight)];
    messageLabel.backgroundColor = backgroundColor;
    messageLabel.font = FUFontAvenirLight(15);
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    
    return messageLabel;
}

@end
