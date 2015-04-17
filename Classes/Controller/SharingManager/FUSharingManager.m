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

+ (void)shareProduct:(FUProduct *)product withViewController:(UIViewController *)viewController completion:(void (^)())completion
{
    [self shareProducts:@[product] withViewController:viewController completion:completion];
}

+ (void)shareProducts:(NSArray *)products withViewController:(UIViewController *)viewController completion:(void (^)())completion
{
    static NSString *const suffix = @"(I found this on www.furn.io)";

    if (products.count == 0 || !viewController) {
        if (completion) {
            completion();
        }
        
        return;
    }

    finishedCount = 0;

    NSMutableArray *sharingItems = [NSMutableArray new];
    
    for (FUProduct *product in products) {
        if (product.name) {
            
            NSString *productURLString = @"";
            
            if (product.seller.houzzURL) {
                productURLString = product.seller.houzzURL.absoluteString;
            }

            NSString *text = [NSString stringWithFormat:@"%@ ($%.2f):\n%@\n\n", product.name, product.price.floatValue, productURLString];
            
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
    
    [sharingItems addObject:suffix];
    
    NSArray *applicationActivities = @[ [AQSFacebookActivity new], [AQSTwitterActivity new]];

    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:applicationActivities];

    activityController.completionHandler = ^(NSString *activityType, BOOL completed) {
        NSString *message;
        UIColor *backgroundColor;
        
        if (completed) {
            message = @"Successfully shared product.";
            backgroundColor = FUColorLightGreen;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:FUSharingManagerDidShareWithSuccessNotification object:nil];
        } else {
            message = @"Couldn't share product.";
            backgroundColor = FUColorLightRed;
        }
        
        [[FUNotifyManager sharedManager] showMessageWithText:message backgroundColor:backgroundColor hideAfterTimeInterval:3.0f];
        
        NSLog(@"%@ completed: %@", activityType, completed ? @"YES" : @"NO");
    };
    
    [viewController presentViewController:activityController animated:YES completion:nil];
}

@end
