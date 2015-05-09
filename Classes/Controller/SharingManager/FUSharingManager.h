//
//  FUSharingManager.h
//  furn
//
//  Created by Markus Bösch on 10/04/15.
//
//

#import <Foundation/Foundation.h>


@class FUProduct;
@class UIViewController;

extern NSString *const FUSharingManagerDidShareWithSuccessNotification;

@interface FUSharingManager : NSObject

+ (void)shareProduct:(FUProduct *)product withViewController:(UIViewController *)viewController completion:(void (^)(BOOL success))completion;

+ (void)shareProducts:(NSArray *)products withViewController:(UIViewController *)viewController completion:(void (^)(BOOL success))completion;

@end
