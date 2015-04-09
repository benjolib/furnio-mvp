//
//  FUCollectionView.m
//  furn
//
//  Created by Markus Bösch on 29/03/15.
//
//

#import "FUCollectionView.h"

#import "FUCatalogColumnCollectionViewCell.h"

@interface FUCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FUCatalogColumnCollectionViewCellDelegate>

@property (assign, nonatomic) FUCollectionViewMode viewMode;

@end

@implementation FUCollectionView


#pragma mark - Initialization

- (void)dealloc
{
    self.dataSource = nil;
    self.delegate = nil;
    self.furnCollectionDelegate = nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.viewMode = FUCollectionViewModeMatrix;

        self.dataSource = self;
        self.delegate = self;
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self registerClass:[FUCatalogColumnCollectionViewCell class] forCellWithReuseIdentifier:FUCatalogColumnCollectionViewCellReuseIdentifier];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewMode == FUCollectionViewModeMatrix ? 10000 : 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FUCatalogColumnCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FUCatalogColumnCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    cell.viewMode = self.viewMode;
    cell.columnIndex = ABS(indexPath.row - [collectionView numberOfItemsInSection:0] / 2);

    cell.delegate = self;

    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;

    CGFloat width = (self.frame.size.width - layout.minimumInteritemSpacing);
    CGFloat height = self.frame.size.height;
    
    if (self.viewMode == FUCollectionViewModeMatrix) {
        width /= 2;
    }

    return CGSizeMake(width, height);
}

#pragma mark - FUCatalogColumnCollectionViewCellDelegate

- (void)columnCell:(FUCatalogColumnCollectionViewCell *)columnCell didSelectProduct:(FUProduct *)product atIndex:(NSInteger)index
{
    if (self.furnCollectionDelegate && [self.furnCollectionDelegate respondsToSelector:@selector(collectionView:didSelectProduct:atIndex:)]) {
        [self.furnCollectionDelegate collectionView:self didSelectProduct:product atIndex:index];
    }
}

- (void)toggleViewMode
{
    self.alpha = 0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25f animations:^{
            self.alpha = 1;
        }];
    });

    if (self.viewMode == FUCollectionViewModeMatrix) {
        self.viewMode = FUCollectionViewModeGrid;
    } else {
        self.viewMode = FUCollectionViewModeMatrix;
    }
}

#pragma mark - Public

- (void)scrollToCenterAnimated:(BOOL)animated
{
    NSUInteger item = [self collectionView:self numberOfItemsInSection:0] / 2;
    
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
}

#pragma mark - Private

- (void)setViewMode:(FUCollectionViewMode)viewMode
{
    if (_viewMode != viewMode) {
        _viewMode = viewMode;

        [self reloadData];
        
        [self scrollToCenterAnimated:YES];
    }
}

@end
