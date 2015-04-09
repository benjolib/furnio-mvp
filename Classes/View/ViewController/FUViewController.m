//
//  ViewController.m
//  furn
//
//  Created by Markus Bösch on 29/03/15.
//
//

#import "FUViewController.h"

@interface FUViewController ()

@end

@implementation FUViewController


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Helper

- (void)setupTransparentNavigationBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}

@end
