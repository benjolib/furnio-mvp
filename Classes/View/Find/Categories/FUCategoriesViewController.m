//
//  FUCategoriesViewController.m
//  furn
//
//  Created by Markus Bösch on 13/04/15.
//
//

#import "FUCategoriesViewController.h"

@interface FUCategoriesViewController ()

@end

@implementation FUCategoriesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"CATEGORIES";
}

- (void)configureNavigationBar
{
    self.navigationBar.leftButton = [self.navigationBar newBackButton];
}

@end
