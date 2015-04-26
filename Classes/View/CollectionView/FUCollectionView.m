//
//  FUCollectionView.m
//  furn
//
//  Created by Markus Bösch on 29/03/15.
//
//

#import "FUCollectionView.h"

#import "FUCatalogColumnCollectionViewCell.h"
#import "FUCatalogEmptyCollectionViewCell.h"
#import "FUProductManager.h"
#import "FUTrackingManager.h"


@interface FUCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FUCatalogColumnCollectionViewCellDelegate, FUCatalogEmptyCollectionViewCellDelegate>

@property (assign, nonatomic) FUCollectionViewMode viewMode;

@end

@implementation FUCollectionView


#pragma mark - Initialization

- (void)dealloc
{
    self.dataSource = nil;
    self.delegate = nil;
    self.furnCollectionDelegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.viewMode = FUCollectionViewModeMatrix;
        
        self.hidden = YES;

        self.dataSource = self;
        self.delegate = self;
        
        [self setupNotifications];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self registerClass:[FUCatalogColumnCollectionViewCell class] forCellWithReuseIdentifier:FUCatalogColumnCollectionViewCellReuseIdentifier];
    [self registerNib:[FUCatalogEmptyCollectionViewCell nib] forCellWithReuseIdentifier:FUCatalogEmptyCollectionViewCellReuseIdentifier];

    self.frame = [UIScreen mainScreen].bounds;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSUInteger columnCount = [FUProductManager sharedManager].columnCount;

    if (columnCount < 2) {
        return 1;
    }

    return self.viewMode == FUCollectionViewModeMatrix ? 10000 : 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger columnCount = [FUProductManager sharedManager].columnCount;

    if (columnCount == 0) {
        FUCatalogEmptyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FUCatalogEmptyCollectionViewCellReuseIdentifier forIndexPath:indexPath];
        
        cell.delegate = self;
        
        return cell;
    } else {
        FUCatalogColumnCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FUCatalogColumnCollectionViewCellReuseIdentifier forIndexPath:indexPath];
        
        cell.viewMode = self.viewMode;
        cell.columnIndex = ABS(indexPath.row - [collectionView numberOfItemsInSection:0] / 2);
        
        cell.delegate = self;

        return cell;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;

    CGFloat width = (collectionView.frame.size.width - layout.minimumInteritemSpacing);
    CGFloat height = collectionView.frame.size.height - layout.sectionInset.top - layout.sectionInset.bottom;

    if (self.viewMode == FUCollectionViewModeMatrix && [FUProductManager sharedManager].productCount > 0) {
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

#pragma mark - FUCatalogEmptyCollectionViewCellDelegate

- (void)didTapResetButton
{
    [[FUProductManager sharedManager] resetAndLoad:YES];
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
    NSUInteger itemCount = [self collectionView:self numberOfItemsInSection:0];
    
    if (itemCount == 0) {
        return;
    }

    NSUInteger item = itemCount / 2;

    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
}

#pragma mark - Notifications

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCollectionViewVisibility) name:FUProductManagerWillStartLoadingPageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:FUProductManagerDidFinishLoadingPageNotification object:nil];
}

- (void)updateCollectionViewVisibility
{
    self.hidden = [FUProductManager sharedManager].productCount == 0;
}

- (void)reload
{
    self.hidden = NO;

    [self reloadData];
    
    [self scrollToCenterAnimated:YES];
}

#pragma mark - Private

- (void)setViewMode:(FUCollectionViewMode)viewMode
{
    if (_viewMode != viewMode) {
        _viewMode = viewMode;
        
        [[FUTrackingManager sharedManager] trackCatalogViewMode:viewMode];

        [self reloadData];
    }
}

@end
