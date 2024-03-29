//
//  ViewController.m
//  furn
//
//  Created by Markus Bösch on 29/03/15.
//
//

#import "FUViewController.h"

@implementation FUViewController


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setupNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureLoadingView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.view bringSubviewToFront:self.navigationBar];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title
{    
    self.navigationBar.title = title;
}

#pragma mark - Private

- (void)setupNavigationBar
{
    if (self.navigationBar) {
        [self.navigationBar removeFromSuperview];
        self.navigationBar = nil;
    }

    self.navigationBar = [[FUNavigationBar alloc] initWithNavigationController:self.navigationController];
    
    [self.view addSubview:self.navigationBar];
    
    [self configureNavigationBar];
}

- (void)setAllowLoadingView:(BOOL)allowLoadingView
{
    [FULoadingViewManager sharedManger].allowLoadingView = allowLoadingView;
}

- (void)configureNavigationBar
{
    // Optional. Subclasses may override this.
}

- (void)configureLoadingView
{
    // Optional. Subclasses may override this.
}

@end
