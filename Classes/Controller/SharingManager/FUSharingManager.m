//
//  FUSharingManager.m
//  furn
//
//  Created by Markus Bösch on 10/04/15.
//
//

#import "FUSharingManager.h"
#import "FUProduct.h"
#import "FUNotifyManager.h"
#import "FUColorConstants.h"
#import "FUTrackingManager.h"
#import "FUWishlistViewController.h"
#import "FUProductDetailBrowserViewController.h"
#import "FUSDKConstants.h"

#import <SDWebImageManager.h>
#import <AQSFacebookActivity.h>
#import <AQSTwitterActivity.h>

NSString *const FUSharingManagerDidShareWithSuccessNotification = @"FUSharingManagerDidShareWithSuccessNotification";

static NSUInteger finishedCount;

@interface FUSharingManager ()

@end

@implementation FUSharingManager


#pragma mark - Initialization

+ (instancetype)sharedManager
{
    static FUSharingManager *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [FUSharingManager new];
    });
    
    return instance;
}

#pragma mark - Public

+ (void)shareProduct:(FUProduct *)product withViewController:(UIViewController *)viewController completion:(void (^)(BOOL success))completion
{
    [self shareProducts:@[product] withViewController:viewController completion:completion];
}

+ (void)shareProducts:(NSArray *)products withViewController:(UIViewController *)viewController completion:(void (^)(BOOL success))completion
{
    if (products.count == 0 || !viewController) {
        if (completion) {
            completion(NO);
        }

        return;
    }

    finishedCount = 0;

    NSMutableArray *sharingItems = [NSMutableArray new];
    
    for (FUProduct *product in products) {
        if (product.name) {
            NSString *text = [NSString stringWithFormat:@"%@ ($%.2f)\n", product.name, product.price.floatValue];
            
            [sharingItems addObject:text];
        }

        UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:product.catalogImageURL.absoluteString];
        
        if (!image) {
            NSData *data = [NSData dataWithContentsOfURL:product.catalogImageURL];
            
            if (data) {
                image = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
            }
        }
        
        [sharingItems addObject:image];
    }
    
    [sharingItems addObject:FUSDKiTunesURL];

    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:[self applicationActivities]];

    activityController.completionHandler = ^(NSString *activityType, BOOL completed) {
        NSString *message;
        UIColor *backgroundColor;
        
        NSString *messageSuffix = products.count > 1 ? @"s" : @"";

        if (completed) {
            message = @"Successfully shared product";
            backgroundColor = FUColorLightGreen;
            
            [self trackSharingSuccessWithProducts:products viewController:viewController];

            [[NSNotificationCenter defaultCenter] postNotificationName:FUSharingManagerDidShareWithSuccessNotification object:nil];
        } else {
            message = @"Couldn't share product";
            backgroundColor = FUColorLightRed;
        }
        
        message = [message stringByAppendingString:messageSuffix];

        [[FUNotifyManager sharedManager] showMessageWithText:message backgroundColor:backgroundColor hideAfterTimeInterval:3.0f isTranslucent:YES];
        
        NSLog(@"%@ completed: %@", activityType, completed ? @"YES" : @"NO");
        
        if (completion) {
            completion(completed);
        }
    };

    [viewController presentViewController:activityController animated:YES completion:nil];
}

+ (NSArray *)applicationActivities
{
    NSMutableArray *activities = [NSMutableArray array];
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        [activities addObject:[AQSFacebookActivity new]];
    }
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
        [activities addObject:[AQSTwitterActivity new]];
    }
    
    return activities;
}

+ (void)trackSharingSuccessWithProducts:(NSArray *)products viewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[FUWishlistViewController class]]) {
        for (FUProduct *product in products) {
            [[FUTrackingManager sharedManager] trackWishlistShareProduct:product];
        }
    }
    
    else if ([viewController isKindOfClass:[FUProductDetailBrowserViewController class]]) {
        for (FUProduct *product in products) {
            [[FUTrackingManager sharedManager] trackPDPShareProduct:product];
        }
    }
}

@end
