//
//  FUSDKManager.m
//  furn
//
//  Created by Markus Bösch on 29/03/15.
//
//

#import "FUSDKManager.h"

#import "FUSDKConstants.h"

#import <AFNetworkActivityIndicatorManager.h>
#import <AFNetworkReachabilityManager.h>
#import <Adjust.h>


@implementation FUSDKManager


#pragma mark - Initialization

+ (void)setup
{
    [self setupAFNetworking];
    [self setupAdjust];
}

+ (instancetype)sharedManager
{
    static FUSDKManager *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [FUSDKManager new];
    });
    
    return instance;
}

#pragma mark - AFNetworking

+ (void)setupAFNetworking
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"ONLINE? %@", status > AFNetworkReachabilityStatusNotReachable ? @"YES" : @"NO");
    }];
}

+ (void)setupAdjust
{
#if STORE
    NSString *environment = ADJEnvironmentProduction;
    BOOL eventBufferingEnabled = YES;
#else
    NSString *environment = ADJEnvironmentSandbox;
    BOOL eventBufferingEnabled = NO;
#endif
    
    ADJConfig *adjustConfig = [ADJConfig configWithAppToken:FUSDKAdjustToken environment:environment];
    adjustConfig.logLevel = ADJLogLevelAssert;
    adjustConfig.eventBufferingEnabled = eventBufferingEnabled;

    [Adjust appDidLaunch:adjustConfig];
}

@end
