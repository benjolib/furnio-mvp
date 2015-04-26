//
//  FUCatalogColumnCollectionViewCell.m
//  furn
//
//  Created by Markus Bösch on 29/03/15.
//
//

#import "FUCatalogColumnCollectionViewCell.h"

#import "FUCatalogCollectionViewCell.h"
#import "FUProductManager.h"
#import "FUImagePrefetcher.h"

#import <UIImageView+WebCache.h>

NSString *const FUCatalogColumnCollectionViewCellReuseIdentifier = @"FUCatalogColumnCollectionViewCellReuseIdentifier";

NSString *const FUCatalogColumnCollectionViewCellScrollingDidStartNotification = @"FUCatalogColumnCollectionViewCellScrollingDidStartNotification";
NSString *const FUCatalogColumnCollectionViewCellScrollingDidFinishNotification = @"FUCatalogColumnCollectionViewCellScrollingDidFinishNotification";


@interface FUCatalogColumnCollectionViewCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *verticalCollectionView;

@end


@implementation FUCatalogColumnCollectionViewCell

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
   return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.verticalCollectionView.dataSource = self;
    self.verticalCollectionView.delegate = self;
    
    [self.verticalCollectionView registerClass:[FUCatalogCollectionViewCell class] forCellWithReuseIdentifier:FUCatalogCollectionViewCellReuseIdentifier];
}

#pragma mark - Setter

- (void)setViewMode:(FUCollectionViewMode)viewMode
{
    _viewMode = viewMode;
    
    self.verticalCollectionView.showsVerticalScrollIndicator = (viewMode == FUCollectionViewModeGrid);
}

- (void)setColumnIndex:(NSUInteger)columnIndex
{
    _columnIndex = columnIndex;

    [self.verticalCollectionView reloadData];

    if (self.viewMode == FUCollectionViewModeMatrix) {
        [self scrollToCenterAnimated:NO];
    } else {
        [self scrollToTopAnimated:NO];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewMode == FUCollectionViewModeMatrix ? 10000 : [FUProductManager sharedManager].productCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FUCatalogCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FUCatalogCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    cell.viewMode = self.viewMode;

    cell.product = [self productAtIndexPath:indexPath];
    
    [self prefetchImagesAtIndexPath:indexPath];

    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.item;

    if (self.viewMode == FUCollectionViewModeMatrix) {
        indexPath = [self actualIndexPathFromPath:indexPath];
        index = [[FUProductManager sharedManager] absoluteIndexForIndexPath:indexPath];
    }

    FUProduct *product = [[FUProductManager sharedManager] productAtIndex:index];

    if (self.delegate && [self.delegate respondsToSelector:@selector(columnCell:didSelectProduct:atIndex:)]) {
        [self.delegate columnCell:self didSelectProduct:product atIndex:index];
    }
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;

    CGFloat width = ([UIScreen mainScreen].bounds.size.width / 2) - layout.minimumInteritemSpacing;

    static CGFloat const height = 250;

    return CGSizeMake(width, height);
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FUCatalogColumnCollectionViewCellScrollingDidStartNotification object:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FUCatalogColumnCollectionViewCellScrollingDidFinishNotification object:nil];
}

#pragma mark - Private

- (void)scrollToCenterAnimated:(BOOL)animated
{
    NSUInteger item = [self collectionView:self.verticalCollectionView numberOfItemsInSection:0] / 2;

    [self.verticalCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:animated];
}

- (void)scrollToTopAnimated:(BOOL)animated
{
    NSUInteger item = 0;

    [self.verticalCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:animated];
}

- (FUProduct *)productAtIndexPath:(NSIndexPath *)indexPath
{
    FUProduct *product;

    if (self.viewMode == FUCollectionViewModeMatrix) {
        indexPath = [self actualIndexPathFromPath:indexPath];
        
        product = [[FUProductManager sharedManager] productForColumnAtIndexPath:indexPath];
    } else {
        product = [[FUProductManager sharedManager] productAtIndex:indexPath.item];
    }

    return product;
}

- (NSIndexPath *)actualIndexPathFromPath:(NSIndexPath *)indexPath
{
    if (self.viewMode == FUCollectionViewModeMatrix) {
        NSInteger item = ABS(indexPath.item - ([self.verticalCollectionView numberOfItemsInSection:0] / 2));
        NSInteger section = self.columnIndex;
        
        indexPath = [NSIndexPath indexPathForItem:item inSection:section];
    }
    
    return indexPath;
}

- (void)prefetchImagesAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger absoluteIndex = indexPath.item;
    
    if (self.viewMode == FUCollectionViewModeMatrix) {
        NSIndexPath *actualIndexPath = [self actualIndexPathFromPath:indexPath];
        absoluteIndex = [[FUProductManager sharedManager] absoluteIndexForIndexPath:actualIndexPath];
    }
    
    [[FUImagePrefetcher sharedPrefetcher] prefetchImagesForProductsAroundIndex:absoluteIndex];
}

@end
