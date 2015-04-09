//
//  FUSDKManager.m
//  furn
//
//  Created by Markus Bösch on 29/03/15.
//
//

#import "FUSDKManager.h"

#import <AFNetworkActivityIndicatorManager.h>
#import <AFNetworkReachabilityManager.h>

@implementation FUSDKManager


#pragma mark - Initialization

+ (void)setup
{
    [self setupAFNetworking];
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

@end
