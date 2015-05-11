//
//  FUOnboardingBaseViewController.m
//  furn
//
//  Created by Markus Bösch on 02/05/15.
//
//

#import "FUOnboardingBaseViewController.h"

#import "FUOnboardingNavigationController.h"
#import "FUOnboardingManager.h"

#import <ADTransitionController.h>

@interface FUOnboardingBaseViewController ()

@property (strong, nonatomic) ADTransitioningDelegate *transitioningDelegate;

@end


@implementation FUOnboardingBaseViewController

#pragma mark - Initialization

- (void)dealloc
{
    self.transitioningDelegate = nil;
}

- (instancetype)init
{
    return [super initWithNibName:@"FUOnboardingBaseViewController" bundle:nil];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTransition];
}

#pragma mark - FUViewController

- (void)configureNavigationBar
{
    self.navigationBar.leftButton = nil;

    self.navigationBar.hidden = YES;
}

#pragma mark - Actions

- (IBAction)switchToNextScreen:(UIGestureRecognizer *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)closeOnboardingScreen:(UIButton *)sender
{
    [FUOnboardingManager sharedManager].completedOnboarding = YES;

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ADTransitionController

- (void)setupTransition
{
    ADTransition *transition = [[ADSwipeFadeTransition alloc] initWithDuration:0.5f orientation:ADTransitionBottomToTop sourceRect:self.view.bounds];
    
    self.transitioningDelegate = [[ADTransitioningDelegate alloc] initWithTransition:transition];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // Subclasses may override this method
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // Subclasses must override this method
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Subclasses must override this method
    return nil;
}

@end
