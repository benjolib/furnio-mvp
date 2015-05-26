//
//  FULoadingViewManager.h
//  furn
//
//  Created by Markus Bösch on 17/04/15.
//
//

#import <Foundation/Foundation.h>

@interface FULoadingViewManager : NSObject

@property (assign, nonatomic, readonly) BOOL isLoading;

@property (assign, nonatomic) BOOL allowLoadingView;

@property (copy, nonatomic) NSString *text;

@property (assign, nonatomic) BOOL hideShadowBackground;

+ (void)setup;

+ (instancetype)sharedManger;

@end
