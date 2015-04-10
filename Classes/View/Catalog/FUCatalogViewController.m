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


@interface FUCatalogViewController () <FUCollectionViewDelegate>

@property (weak, nonatomic) IBOutlet FUCollectionView *horizontalCollectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonContainerViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;

@property (weak, nonatomic) IBOutlet UIButton *filterButton;

@property (weak, nonatomic) IBOutlet UIButton *sortButton;

@property (weak, nonatomic) IBOutlet UIButton *viewModeButton;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (weak, nonatomic) IBOutlet UIButton *wishlistButton;

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

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideButtonBar) name:FUCatalogColumnCollectionViewCellScrollingDidStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showButtonBar) name:FUCatalogColumnCollectionViewCellScrollingDidFinishNotification object:nil];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.horizontalCollectionView.furnCollectionDelegate = self;
    
    [self.horizontalCollectionView scrollToCenterAnimated:NO];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.searchButton.hitTestEdgeInsets = UIEdgeInsetsMake(-15, -15, -5, -5);
    self.wishlistButton.hitTestEdgeInsets = UIEdgeInsetsMake(-15, -5, -5, -15);
}

#pragma mark - Notifications

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

#pragma mark - Actions

- (IBAction)viewModeButtonTapped:(id)sender
{
    [self.horizontalCollectionView toggleViewMode];
    
    [self toggleViewModeButtonImage];
}

- (IBAction)filterButtonTapped:(id)sender
{
    // TODO: Attach Filter VC here
    
}

- (IBAction)sortButtonTapped:(id)sender
{
    // TODO: Attach Sort VC here
}

- (IBAction)searchButtonTapped:(id)sender
{
    [sender animateScaling];

    // TODO: Attach Search VC here
}

- (IBAction)wishlistButtonTapped:(UIButton *)sender
{
    [sender animateScaling];
    
    FUWishlistViewController *wishlistViewController = [FUWishlistViewController new];
    
    FUNavigationController *wishlistNavigationController = [[FUNavigationController alloc] initWithRootViewController:wishlistViewController];
    
    [self.navigationController presentViewController:wishlistNavigationController animated:YES completion:nil];
}


#pragma mark - FUCollectionViewDelegate

- (void)collectionView:(FUCollectionView *)collectionView didSelectProduct:(FUProduct *)product atIndex:(NSInteger)index
{
    // TODO: Open PDP after tapping on product

    NSLog(@"%@: %@ ($%.2f)", @(index), product.name, product.price.floatValue);
}

#pragma mark - Private

- (void)toggleViewModeButtonImage
{
    NSString *imageName = self.horizontalCollectionView.viewMode == FUCollectionViewModeMatrix ? @"grid-view" : @"matrix-view";
    
    [self.viewModeButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

@end
