//
//  FUNavigationController.m
//  furn
//
//  Created by Markus Bösch on 29/03/15.
//
//

#import "FUNavigationController.h"

@implementation FUNavigationController

#pragma mark - UIViewController

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
