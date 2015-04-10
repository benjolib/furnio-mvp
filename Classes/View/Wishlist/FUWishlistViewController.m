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


@interface FUWishlistViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FUWishlistCollectionViewCellDelegate, FUWishlistEmptyCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UICollectionView *wishlistCollectionView;

@property (assign, nonatomic) FUWishlistViewState viewState;

@property (weak, nonatomic) IBOutlet UIView *allItemsContainer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allItemsContainerHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *deleteAllButton;

@property (weak, nonatomic) IBOutlet UIButton *shareAllButton;

@end

@implementation FUWishlistViewController


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewState = FUWishlistViewStateNormal;

    [self.wishlistCollectionView registerNib:[FUWishlistCollectionViewCell nib] forCellWithReuseIdentifier:FUWishlistCollectionViewCellReuseIdentifier];
    
    [self.wishlistCollectionView registerNib:[FUWishlistEmptyCollectionViewCell nib] forCellWithReuseIdentifier:FUWishlistEmptyCollectionViewCellReuseIdentifier];
}

#pragma mark - Actions

- (IBAction)closeButtonTapped:(UIButton *)sender
{
    [sender animateScaling];

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editButtonTapped:(UIButton *)sender
{
    [sender animateScaling];

    [self toggleViewState];
}

- (IBAction)deleteAllButtonTapped:(id)sender
{
    [[FUWishlistManager sharedManager] removeAllProducts];

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
    
    [self.wishlistCollectionView reloadData];
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
    // TODO: Attach PDP VC here to present product

    // FUProduct *product = [self.products objectAtIndex:indexPath.item];
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

- (void)wishlistCollectionViewCell:(FUWishlistCollectionViewCell *)wishlistCollectionViewCell didTapDeleteButtonWithProduct:(FUProduct *)product
{
    NSIndexPath *indexPath = [self.wishlistCollectionView indexPathForCell:wishlistCollectionViewCell];

    [[FUWishlistManager sharedManager] removeProductAtIndex:indexPath.item];

    if (self.products.count == 0) {
        self.viewState = FUWishlistViewStateNormal;
    } else {
        [self.wishlistCollectionView deleteItemsAtIndexPaths:@[indexPath]];
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

- (NSArray *)products
{
    return [FUWishlistManager sharedManager].products;
}

@end
