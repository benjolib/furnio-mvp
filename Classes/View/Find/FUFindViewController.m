//
//  FUFindViewController.m
//  furn
//
//  Created by Markus Bösch on 13/04/15.
//
//

#import "FUFindViewController.h"

#import "FUColorConstants.h"
#import "FUCategoriesViewController.h"
#import "UIView+FUAnimations.h"
#import "FUNavigationController.h"

@interface FUFindViewController ()

@end

@implementation FUFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = FUColorOrange;
    
    self.navigationBar.leftButton.tintColor = [UIColor whiteColor];
    
    UIImage *closeButtonImage = [self.navigationBar.leftButton imageForState:UIControlStateNormal];
    
    [self.navigationBar.leftButton setImage:[closeButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
}

#pragma mark - Actions

- (IBAction)searchButtonTapped:(UIButton *)sender
{
    [sender animateScaling];
    
}

- (IBAction)categoryButtonTapped:(UIButton *)sender
{
    [sender animateScaling];
    
    [self.navigationController pushViewController:[FUCategoriesViewController new] animated:YES];
}

@end
