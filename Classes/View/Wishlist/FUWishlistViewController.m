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
#import "FUColorConstants.h"

@interface FUWishlistViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FUWishlistCollectionViewCellDelegate, FUWishlistEmptyCollectionViewCellDelegate>

@property (strong, nonatomic, readonly) UIButton *editButton;

@property (weak, nonatomic) IBOutlet UICollectionView *wishlistCollectionView;

@property (assign, nonatomic) FUWishlistViewState viewState;

@property (weak, nonatomic) IBOutlet UIView *allItemsContainer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allItemsContainerHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *deleteAllButton;

@property (weak, nonatomic) IBOutlet UIButton *shareAllButton;

@property (strong, nonatomic) NSMutableIndexSet *selectedIndicesToDelete;
@property (strong, nonatomic) NSMutableIndexSet *selectedIndicesToShare;

@property (assign, nonatomic) BOOL deleteAllProducts;
@property (assign, nonatomic) BOOL shareAllProducts;

@end

@implementation FUWishlistViewController


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"WISHLIST";

    [self.wishlistCollectionView registerNib:[FUWishlistCollectionViewCell nib] forCellWithReuseIdentifier:FUWishlistCollectionViewCellReuseIdentifier];
    
    [self.wishlistCollectionView registerNib:[FUWishlistEmptyCollectionViewCell nib] forCellWithReuseIdentifier:FUWishlistEmptyCollectionViewCellReuseIdentifier];
    
    self.selectedIndicesToDelete = [NSMutableIndexSet indexSet];
    self.selectedIndicesToShare = [NSMutableIndexSet indexSet];
    
    self.viewState = FUWishlistViewStateNormal;
    
    self.screenName = @"Wishlist";
}

#pragma mark - Actions

- (void)editButtonTapped:(UIButton *)sender
{
    [sender animateScaling];

    [self toggleViewState];
}

- (IBAction)deleteAllButtonTapped:(UIButton *)sender
{
    self.deleteAllProducts = !self.deleteAllProducts;
    
    if (self.deleteAllProducts) {
        [self.selectedIndicesToDelete addIndexesInRange:NSMakeRange(0, [FUWishlistManager sharedManager].products.count)];
    } else {
        [self.selectedIndicesToDelete removeAllIndexes];
    }
    
    [self.wishlistCollectionView reloadData];

    [self toggleStateOfButton:sender selected:self.deleteAllProducts tintColor:FUColorDarkGray];
}

- (IBAction)shareAllButtonTapped:(UIButton *)sender
{
    self.shareAllProducts = !self.shareAllProducts;
    
    if (self.shareAllProducts) {
        [self.selectedIndicesToShare addIndexesInRange:NSMakeRange(0, [FUWishlistManager sharedManager].products.count)];
    } else {
        [self.selectedIndicesToShare removeAllIndexes];
    }

    [self.wishlistCollectionView reloadData];

    [self toggleStateOfButton:sender selected:self.shareAllProducts tintColor:FUColorOrange];
}

- (void)shareSelectedProducts
{
    NSArray *products = [[[FUWishlistManager sharedManager].products objectsAtIndexes:self.selectedIndicesToShare] copy];

    if (products.count > 0) {
        [FUSharingManager shareProducts:products withViewController:self completion:^(BOOL success) {
            [self.selectedIndicesToShare removeAllIndexes];
                
            [self.wishlistCollectionView reloadData];
        }];
    }
}

- (void)deleteSelectedProducts
{
    [[FUWishlistManager sharedManager] removeProductsAtIndexes:self.selectedIndicesToDelete];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    [self.selectedIndicesToDelete enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:index inSection:0]];
    }];
    
    if ([FUWishlistManager sharedManager].products.count > 0) {
        [self.wishlistCollectionView performBatchUpdates:^{
            [self.wishlistCollectionView deleteItemsAtIndexPaths:indexPaths];
            
        } completion:^(BOOL finished) {
            [self.selectedIndicesToDelete removeAllIndexes];
            
            [self.wishlistCollectionView reloadData];
        }];
    } else {
        [self.wishlistCollectionView reloadData];
    }
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

    if (viewState == FUWishlistViewStateNormal && self.products.count > 0) {
        if (self.shareAllProducts) {
            [FUSharingManager shareProducts:self.products withViewController:self completion:nil];
        }
        
        if (self.deleteAllProducts) {
            [[FUWishlistManager sharedManager] removeAllProducts];

            self.viewState = FUWishlistViewStateNormal;
            
            [self.wishlistCollectionView reloadData];
        }
        
        if (self.shareAllProducts || self.deleteAllProducts) {
            self.shareAllProducts = NO;
            self.deleteAllProducts = NO;
            
            return;
        }

        if (self.selectedIndicesToShare.count > 0) {
            [self shareSelectedProducts];
        }
        
        if (self.selectedIndicesToDelete.count > 0) {
            [self deleteSelectedProducts];
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
        
        cell.deleteButton.selected = [self.selectedIndicesToDelete containsIndex:indexPath.item];
        cell.shareButton.selected = [self.selectedIndicesToShare containsIndex:indexPath.item];
        
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
    if (indexPath.item >= self.products.count) {
        return;
    }

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
        [self.selectedIndicesToDelete addIndex:indexPath.item];
    } else {
        [self.selectedIndicesToDelete removeIndex:indexPath.item];
    }
    
    self.deleteAllProducts = (self.selectedIndicesToDelete.count == [FUWishlistManager sharedManager].products.count);

    [self toggleStateOfButton:self.deleteAllButton selected:self.deleteAllProducts tintColor:FUColorDarkGray];
}

- (void)wishlistCollectionViewCell:(FUWishlistCollectionViewCell *)wishlistCollectionViewCell didTapShareButtonWithProduct:(FUProduct *)product isSelected:(BOOL)selected
{
    NSIndexPath *indexPath = [self.wishlistCollectionView indexPathForCell:wishlistCollectionViewCell];
    
    if (selected) {
        [self.selectedIndicesToShare addIndex:indexPath.item];
    } else {
        [self.selectedIndicesToShare removeIndex:indexPath.item];
    }
    
    self.shareAllProducts = (self.selectedIndicesToShare.count == [FUWishlistManager sharedManager].products.count);
    
    [self toggleStateOfButton:self.shareAllButton selected:self.shareAllProducts tintColor:FUColorOrange];
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

- (void)toggleStateOfButton:(UIButton *)button selected:(BOOL)selected tintColor:(UIColor *)tintColor
{
    if (selected) {
        button.backgroundColor = tintColor;
        button.tintColor = [UIColor whiteColor];
    } else {
        button.backgroundColor = [UIColor clearColor];
        button.tintColor = tintColor;
    }
}

@end
