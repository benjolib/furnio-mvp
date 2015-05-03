//
//  FUOnboardingManager.h
//  furn
//
//  Created by Markus Bösch on 03/05/15.
//
//

#import <Foundation/Foundation.h>

@interface FUOnboardingManager : NSObject

@property (assign, nonatomic) BOOL completedOnboarding;

+ (instancetype)sharedManager;

- (void)evaluateOnboarding;

@end
