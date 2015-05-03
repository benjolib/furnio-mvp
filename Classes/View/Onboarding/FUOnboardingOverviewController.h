//
//  FUOnboardingOverviewController.h
//  furn
//
//  Created by Markus Bösch on 03/05/15.
//
//

#import "FUOnboardingBaseViewController.h"

@interface FUOnboardingOverviewController : FUOnboardingBaseViewController

@property (readonly, nonatomic) NSUInteger stepIndex;

- (instancetype)initWithStepIndex:(NSUInteger)stepIndex;

@end
