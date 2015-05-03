//
//  FUWishlistViewController.m
//  furn
//
//  Created by Markus Bösch on 09/04/15.
//
//

#import "FUWishlistViewController.h"

#import "UIView+FUAnimations.h"
#import "FUWishlistManager.h"
#import "FUWishlistEmptyCollectionViewCell.h"
#import "FUSharingManager.h"
#import "UIControl+HitTest.h"
#import "FUWishlistActionButton.h"
#import "FUProductDetailPageViewController.h"

@interface FUWishlistViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FUWishlistCollectionViewCellDelegate, FUWishlistEmptyCollectionViewCellDelegate>

@property (strong, nonatomic, readonly) UIButton *editButton;

@property (weak, nonatomic) IBOutlet UICollectionView *wishlistCollectionView;

@property (assign, nonatomic) FUWishlistViewState viewState;

@property (weak, nonatomic) IBOutlet UIView *allItemsContainer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allItemsContainerHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *deleteAllButton;

@property (weak, nonatomic) IBOutlet UIButton *shareAllButton;

@property (strong, nonatomic) NSMutableIndexSet *selectedIndices;

@end

@implementation FUWishlistViewController


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"WISHLIST";

    [self.wishlistCollectionView registerNib:[FUWishlistCollectionViewCell nib] forCellWithReuseIdentifier:FUWishlistCollectionViewCellReuseIdentifier];
    
    [self.wishlistCollectionView registerNib:[FUWishlistEmptyCollectionViewCell nib] forCellWithReuseIdentifier:FUWishlistEmptyCollectionViewCellReuseIdentifier];
    
    self.selectedIndices = [NSMutableIndexSet indexSet];
    
    self.viewState = FUWishlistViewStateNormal;
}

#pragma mark - Actions

- (void)editButtonTapped:(UIButton *)sender
{
    [sender animateScaling];

    [self toggleViewState];
}

- (IBAction)deleteAllButtonTapped:(id)sender
{
    [[FUWishlistManager sharedManager] removeAllProducts];
    
    self.viewState = FUWishlistViewStateNormal;

    [self.wishlistCollectionView reloadData];
}

- (IBAction)shareAllButtonTapped:(id)sender
{
    [FUSharingManager shareProducts:self.products withViewController:self completion:nil];
}

#pragma mark - Setter

- (void)setViewState:(FUWishlistViewState)viewState
{
    _viewState = viewState;
    
    NSString *imageName = viewState == FUWishlistViewStateNormal ? @"edit" : @"check-arrow";
    
    [self.editButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    self.editButton.enabled = self.products.count > 0;

    self.allItemsContainerHeightConstraint.constant = viewState == FUWishlistViewStateNormal ? 0 : 40;
    self.allItemsContainer.hidden = viewState == FUWishlistViewStateNormal;

    if (viewState == FUWishlistViewStateNormal && self.selectedIndices.count > 0 && self.products.count > 0) {
        [[FUWishlistManager sharedManager] removeProductsAtIndexes:self.selectedIndices];
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        
        [self.selectedIndices enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:index inSection:0]];
        }];

        if ([FUWishlistManager sharedManager].products.count > 0) {
            [self.wishlistCollectionView performBatchUpdates:^{
                [self.wishlistCollectionView deleteItemsAtIndexPaths:indexPaths];
                
            } completion:^(BOOL finished) {
                [self.selectedIndices removeAllIndexes];

                [self.wishlistCollectionView reloadData];
            }];
        } else {
            [self.wishlistCollectionView reloadData];
        }
    } else {
        [self.wishlistCollectionView reloadData];
    }
}

#pragma mark - Private

- (void)toggleViewState
{
    if (self.viewState == FUWishlistViewStateNormal) {
        self.viewState = FUWishlistViewStateEdit;
    } else {
        self.viewState = FUWishlistViewStateNormal;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MAX(1, self.products.count);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.products.count > 0) {
        FUWishlistCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FUWishlistCollectionViewCellReuseIdentifier forIndexPath:indexPath];
        
        cell.product = [self.products objectAtIndex:indexPath.item];
        cell.viewState = self.viewState;

        cell.delegate = self;
        
        cell.deleteButton.selected = [self.selectedIndices containsIndex:indexPath.item];
        
        return cell;
    } else {
        FUWishlistEmptyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FUWishlistEmptyCollectionViewCellReuseIdentifier forIndexPath:indexPath];
        
        cell.delegate = self;
        
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     FUProduct *product = [self.products objectAtIndex:indexPath.item];
    
    FUProductDetailPageViewController *detailPageViewController = [[FUProductDetailPageViewController alloc] initWithSingleProduct:product];
    
    [self.navigationController pushViewController:detailPageViewController animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.products.count == 0) {
        return self.wishlistCollectionView.frame.size;
    } else {
        CGFloat width = [UIScreen mainScreen].bounds.size.width / 2;
        CGFloat height = 250;
        
        return CGSizeMake(width, height);
    }
}

#pragma mark - FUWishlistCollectionViewCellDelegate

- (void)wishlistCollectionViewCell:(FUWishlistCollectionViewCell *)wishlistCollectionViewCell didTapDeleteButtonWithProduct:(FUProduct *)product isSelected:(BOOL)selected
{
    NSIndexPath *indexPath = [self.wishlistCollectionView indexPathForCell:wishlistCollectionViewCell];

    if (selected) {
        [self.selectedIndices addIndex:indexPath.item];
    } else {
        [self.selectedIndices removeIndex:indexPath.item];
    }
}

- (void)wishlistCollectionViewCell:(FUWishlistCollectionViewCell *)wishlistCollectionViewCell didTapShareButtonWithProduct:(FUProduct *)product
{
    [FUSharingManager shareProduct:product withViewController:self completion:nil];
}

#pragma mark - FUWishlistEmptyCollectionViewCellDelegate

- (void)didPressStartSwipingButton
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

- (void)configureNavigationBar
{
    self.navigationBar.rightButton = [self.navigationBar newButtonWithImage:[UIImage imageNamed:@"edit"] target:self selector:@selector(editButtonTapped:) position:FUNavigationBarButtonPositionRight];
}

- (NSArray *)products
{
    return [FUWishlistManager sharedManager].products;
}

- (UIButton *)editButton
{
    return self.navigationBar.rightButton;
}

@end
