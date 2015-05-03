//
//  FUOnboardingNavigationController.m
//  furn
//
//  Created by Markus Bösch on 02/05/15.
//
//

#import "FUOnboardingNavigationController.h"

#import "FUColorConstants.h"

#import <ADNavigationControllerDelegate.h>


@interface FUOnboardingNavigationController ()

@property (strong, nonatomic) ADNavigationControllerDelegate *animationDelegate;

@end


@implementation FUOnboardingNavigationController

#pragma mark - Initialization

- (void)dealloc
{
    self.animationDelegate = nil;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self setupTransitioning];
    }

    return self;
}

#pragma mark - ADNavigationController

- (void)setupTransitioning
{
    self.animationDelegate = [ADNavigationControllerDelegate new];

    self.delegate = self.animationDelegate;
}

@end
