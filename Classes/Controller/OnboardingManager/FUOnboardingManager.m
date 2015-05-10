//
//  FUOnboardingManager.m
//  furn
//
//  Created by Markus Bösch on 03/05/15.
//
//

#import "FUOnboardingManager.h"

#import "FUOnboardingNavigationController.h"
#import "FUOnboardingBaseViewController.h"
#import "FUOnboardingOverviewController.h"
#import "FUOnboardingAreaCategoryViewController.h"
#import "FUOnboardingAreaStyleViewController.h"
#import "FUOnboardingAreaRoomViewController.h"
#import "FULoadingViewManager.h"
#import "FUSplashViewController.h"

static NSString *const FUUserDefaultsCompletedOnboarding = @"FUOnboardingManagerCompletedOnboarding";

@interface FUOnboardingManager ()

@property (strong, nonatomic) NSArray *viewControllers;

@end


@implementation FUOnboardingManager

@synthesize completedOnboarding = _completedOnboarding;


+ (instancetype)sharedManager
{
    static FUOnboardingManager *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [FUOnboardingManager new];
    });
    
    return instance;
}

#pragma mark - Setter

- (void)setCompletedOnboarding:(BOOL)completedOnboarding
{
    if (_completedOnboarding == completedOnboarding) {
        return;
    }

    _completedOnboarding = completedOnboarding;
    
    [[NSUserDefaults standardUserDefaults] setBool:completedOnboarding forKey:FUUserDefaultsCompletedOnboarding];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Getter

- (BOOL)completedOnboarding
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _completedOnboarding = [[NSUserDefaults standardUserDefaults] boolForKey:FUUserDefaultsCompletedOnboarding];
    });
    
    return _completedOnboarding;
}

#pragma mark - Onboarding

- (void)evaluateOnboarding
{
    if (!self.completedOnboarding) {
        [self showOnboarding];
    }
    
    [FULoadingViewManager sharedManger].allowLoadingView = self.completedOnboarding;
}

- (void)showOnboarding
{
    FUOnboardingNavigationController *onboardingNavigationController = [FUOnboardingNavigationController new];

    self.viewControllers = @[
        [FUOnboardingAreaRoomViewController new],
        [[FUOnboardingOverviewController alloc] initWithStepIndex:2],
        [FUOnboardingAreaStyleViewController new],
        [[FUOnboardingOverviewController alloc] initWithStepIndex:1],
        [FUOnboardingAreaCategoryViewController new],
        [[FUOnboardingOverviewController alloc] initWithStepIndex:0],
        [FUSplashViewController new]
    ];

    onboardingNavigationController.viewControllers = self.viewControllers;
    
    UINavigationController *rootNavigationController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;

    
    [rootNavigationController presentViewController:onboardingNavigationController animated:NO completion:nil];
}

@end
