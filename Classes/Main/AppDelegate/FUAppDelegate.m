//
//  AppDelegate.m
//  furn
//
//  Created by Markus Bösch on 29/03/15.
//
//

#import "FUAppDelegate.h"

#import "FUSDKManager.h"
#import "FUDeepLinkHandler.h"

#import "FUNavigationController.h"
#import "FUCatalogViewController.h"

#import "FUProduct.h"
#import "FUProductList.h"


@implementation FUAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FUSDKManager setup];
    
    [FUDeepLinkHandler setupWithURLScheme:@"furn"];

    [self setupRootController];

    return YES;
}

- (void)setupRootController
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [[FUNavigationController alloc] initWithRootViewController:[FUCatalogViewController new]];
    
    [self.window makeKeyAndVisible];
}

#pragma mark - Deep Linking

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[FUDeepLinkHandler sharedHandler] handleURL:url completion:^(BOOL handled, NSError *error) {
        if (!handled) {
            NSLog(@"%@", error);
        }
    }];
    
    return YES;
}

#pragma mark - Debug

#if 0

- (void)printAllFonts
{
    for (NSString *family in [UIFont familyNames]) {
        NSLog(@"%@", family);
        
        for (NSString *name in [UIFont fontNamesForFamilyName:family]) {
            NSLog(@"  %@", name);
        }
    }
}

#endif

@end
