//
//  FUAppirater.h
//  furn
//
//  Created by Markus Bösch on 01/05/15.
//

#import "FUAppirater.h"

#import "FUAlertView.h"


@interface Appirater ()

- (void)showPromptWithChecks:(BOOL)withChecks
      displayRateLaterButton:(BOOL)displayRateLaterButton;

- (void)incrementAndRate:(BOOL)canPromptForRating;

- (void)incrementSignificantEventAndRate:(BOOL)canPromptForRating;

- (void)incrementUseCount;

- (void)incrementSignificantEventCount;

- (void)tryToShopPrompt;

@end


@interface FUAppirater () <FUAlertViewDelegate>

@end


@implementation FUAppirater

#pragma mark - Appirater

+ (FUAppirater *)sharedInstance {
    static FUAppirater *appirater = nil;
    if (appirater == nil) {
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            appirater = [[FUAppirater alloc] init];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:
             UIApplicationWillResignActiveNotification object:nil];
        });
    }
    
    return appirater;
}

- (void)showRatingAlert:(BOOL)displayRateLaterButton {
    FUAlertView *alertView = [[FUAlertView alloc] initWithTitle:@"YOU LIKE THE APP?"
                                                        message:@"Spread the word and rate us at the app store."
                                                       delegate:self
                                              cancelButtonTitle:@"RATE LATER"
                                             confirmButtonTitle:@"RATE NOW"];

    self.alertView = alertView;
    
    [alertView show:YES];
    
    [self incrementSignificantEventCount];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(appiraterDidDisplayAlert:)]) {
        [self.delegate appiraterDidDisplayAlert:self];
    }
}

- (void)hideRatingAlert {
    if (self.alertView.visible) {
        [self.alertView hide:YES];
    }
}

- (void)incrementUseCount
{
    NSInteger useCount = [[NSUserDefaults standardUserDefaults] integerForKey:kAppiraterUseCount];
    
    if (useCount == 0) {
        [self performSelectorOnMainThread:@selector(delayTryToShowPrompt) withObject:nil waitUntilDone:NO];
    }
    else if (useCount < 5) {
        [FUAppirater setUsesUntilPrompt:5];
    }
    else if (useCount < 10) {
        [FUAppirater setUsesUntilPrompt:10];
    }
    else if (useCount < 20) {
        [FUAppirater setUsesUntilPrompt:20];
    }
    else {
        [FUAppirater setUsesUntilPrompt:NSIntegerMax];
    }
    
    [super incrementUseCount];
}

- (void)delayTryToShowPrompt
{
    NSTimeInterval minutesUntilPrompt = 10.0f;

    [self performSelector:@selector(tryToShowPrompt) withObject:nil afterDelay:minutesUntilPrompt * 60];
}

- (void)tryToShowPrompt
{
    [self showPromptWithChecks:true displayRateLaterButton:true];
}

+ (void)tryToShowPrompt {
    [[self sharedInstance] showPromptWithChecks:true
                         displayRateLaterButton:true];
}

+ (void)forceShowPrompt:(BOOL)displayRateLaterButton {
    [[self sharedInstance] showPromptWithChecks:false
                         displayRateLaterButton:displayRateLaterButton];
}

+ (void)appWillResignActive {
    [[self sharedInstance] hideRatingAlert];
}

+ (void)appLaunched:(BOOL)canPromptForRating {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
                   ^{
                       [[self sharedInstance] incrementAndRate:canPromptForRating];
                   });
}

+ (void)appEnteredForeground:(BOOL)canPromptForRating {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
                   ^{
                       [[self sharedInstance] incrementAndRate:canPromptForRating];
                   });
}

+ (void)userDidSignificantEvent:(BOOL)canPromptForRating {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
                   ^{
                       [[self sharedInstance] incrementSignificantEventAndRate:canPromptForRating];
                   });
}

#pragma mark - HOAlertViewDelegate

- (void)alertViewCancel:(FUAlertView *)alertView
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:kAppiraterReminderRequestDate];
    
    [userDefaults synchronize];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(appiraterDidOptToRemindLater:)]) {
        [self.delegate appiraterDidOptToRemindLater:self];
    }
}

- (void)alertViewClose:(FUAlertView *)alertView
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:kAppiraterReminderRequestDate];
    
    [userDefaults synchronize];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(appiraterDidOptToRemindLater:)]) {
        [self.delegate appiraterDidOptToRemindLater:self];
    }
}

- (void)alertViewConfirm:(FUAlertView *)alertView
{
    [FUAppirater rateApp];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(appiraterDidOptToRate:)]) {
        [self.delegate appiraterDidOptToRate:self];
    }
}

@end
