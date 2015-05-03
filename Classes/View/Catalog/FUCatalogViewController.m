//
//  FUCatalogViewController.m
//  furn
//
//  Created by Markus Bösch on 29/03/15.
//
//

#import "FUCatalogViewController.h"

#import "FUCollectionView.h"
#import "FUCatalogColumnCollectionViewCell.h"
#import "FUProduct.h"
#import "UIView+FUAnimations.h"
#import "FUWishlistViewController.h"
#import "FUNavigationController.h"
#import "UIControl+HitTest.h"
#import "FUSearchViewController.h"
#import "FUProductManager.h"
#import "FUWishlistManager.h"
#import "FUProductDetailPageViewController.h"
#import "FUFilterViewController.h"
#import "UIImage+ImageEffects.h"
#import "FUOnboardingManager.h"
#import "FUSortingViewController.h"

@interface FUCatalogViewController () <FUCollectionViewDelegate>

@property (weak, nonatomic) IBOutlet FUCollectionView *horizontalCollectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonContainerViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;

@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UIButton *sortButton;
@property (weak, nonatomic) IBOutlet UIButton *viewModeButton;

@end


@implementation FUCatalogViewController


#pragma mark - Init

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self setupNotifications];
    }
    
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.horizontalCollectionView.furnCollectionDelegate = self;

    self.navigationController.navigationBarHidden = YES;
    
    // hide button bar initially
    self.buttonContainerViewBottomConstraint.constant = -self.buttonContainerView.frame.size.height;
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([FUProductManager sharedManager].isDirty) {
        [self.horizontalCollectionView reloadData];
        
        for (FUCatalogColumnCollectionViewCell *cell in self.horizontalCollectionView.visibleCells) {
            [cell.verticalCollectionView reloadData];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[FUOnboardingManager sharedManager] evaluateOnboarding];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [self showButtonBar];
}

#pragma mark - FUViewController

- (void)configureLoadingView
{
    [FULoadingViewManager sharedManger].text = @"LOADING PRODUCTS";
}

- (void)configureNavigationBar
{
    self.navigationBar.originY = FUNavigationBarButtonMarginX;
    self.navigationBar.height = FUNavigationBarDefaultHeight * 2;
    
    self.navigationBar.leftButton = [self.navigationBar newRoundedYellowButtonWithImage:[UIImage imageNamed:@"search"] target:self selector:@selector(searchButtonTapped:) position:FUNavigationBarButtonPositionLeft];
    
    self.navigationBar.rightButton = [self.navigationBar newRoundedYellowButtonWithImage:[UIImage imageNamed:@"wishlist"] target:self selector:@selector(wishlistButtonTapped:) position:FUNavigationBarButtonPositionRight];
}

#pragma mark - Notifications

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideButtonBar) name:FUProductManagerWillStartLoadingPageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showButtonBar) name:FUProductManagerDidFinishLoadingPageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideButtonBar) name:FUCatalogColumnCollectionViewCellScrollingDidStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showButtonBar) name:FUCatalogColumnCollectionViewCellScrollingDidFinishNotification object:nil];
}

- (void)hideButtonBar
{
    self.buttonContainerViewBottomConstraint.constant = -self.buttonContainerView.frame.size.height;
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)showButtonBar
{
    self.buttonContainerViewBottomConstraint.constant = 0;
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(UIImage *)convertViewToImage
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Actions

- (IBAction)viewModeButtonTapped:(id)sender
{
    [self.horizontalCollectionView toggleViewMode];
    
    [self toggleViewModeButtonImage];
}

- (IBAction)filterButtonTapped:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Filter" bundle:nil];
    FUNavigationController *filterNavigationViewController = [storyboard instantiateInitialViewController];
    FUFilterViewController *filterViewController = [filterNavigationViewController.viewControllers lastObject];
    
    UIImage* imageOfUnderlyingView = [self convertViewToImage];
    imageOfUnderlyingView = [imageOfUnderlyingView applyBlurWithRadius:20 tintColor:[UIColor colorWithWhite:1.0 alpha:0.6] saturationDeltaFactor:1.8 maskImage:nil];
    filterViewController.view.backgroundColor = [UIColor colorWithPatternImage:imageOfUnderlyingView];

    [self.navigationController presentViewController:filterNavigationViewController animated:YES completion:nil];
}

- (IBAction)sortButtonTapped:(id)sender
{
    FUSortingViewController *sortingViewController = [FUSortingViewController new];
    FUNavigationController *sortingNavigationViewController = [[FUNavigationController alloc] initWithRootViewController:sortingViewController];
    
    UIImage* imageOfUnderlyingView = [self convertViewToImage];
    imageOfUnderlyingView = [imageOfUnderlyingView applyBlurWithRadius:20 tintColor:[UIColor colorWithWhite:1.0 alpha:0.6] saturationDeltaFactor:1.8 maskImage:nil];
    sortingViewController.view.backgroundColor = [UIColor colorWithPatternImage:imageOfUnderlyingView];
    
    [self.navigationController presentViewController:sortingNavigationViewController animated:YES completion:nil];
}

- (void)searchButtonTapped:(UIButton *)sender
{
    [sender animateScaling];

    FUNavigationController *searchNavigationController = [[FUNavigationController alloc] initWithRootViewController:[FUSearchViewController new]];

    [self.navigationController presentViewController:searchNavigationController animated:YES completion:nil];
}

- (void)wishlistButtonTapped:(UIButton *)sender
{
    [sender animateScaling];
    
    FUWishlistViewController *wishlistViewController = [FUWishlistViewController new];
    
    FUNavigationController *wishlistNavigationController = [[FUNavigationController alloc] initWithRootViewController:wishlistViewController];
    
    [self.navigationController presentViewController:wishlistNavigationController animated:YES completion:nil];
}


#pragma mark - FUCollectionViewDelegate

- (void)collectionView:(FUCollectionView *)collectionView didSelectProduct:(FUProduct *)product atIndex:(NSInteger)index
{
    FUProductDetailPageViewController *detailPageViewController = [FUProductDetailPageViewController new];
    detailPageViewController.product = product;
    
    [self.navigationController pushViewController:detailPageViewController animated:YES];

    NSLog(@"%@: %@ ($%.2f)", @(index), product.name, product.price.floatValue);
}

#pragma mark - Private

- (void)toggleViewModeButtonImage
{
    NSString *imageName = self.horizontalCollectionView.viewMode == FUCollectionViewModeMatrix ? @"grid-view" : @"matrix-view";
    
    [self.viewModeButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

@end
