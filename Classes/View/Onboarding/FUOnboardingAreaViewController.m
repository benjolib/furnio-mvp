//
//  FUOnboardingAreaViewController.m
//  furn
//
//  Created by Markus Bösch on 03/05/15.
//
//

#import "FUOnboardingAreaViewController.h"

#import "FUOnboardingAreaCollectionViewCell.h"
#import "FUColorConstants.h"
#import "FUTrackingManager.h"

static NSUInteger pageIndex = 0;

@interface FUOnboardingAreaViewController ()

@property (strong, nonatomic) NSMutableIndexSet *selectedIndices;

@end

@implementation FUOnboardingAreaViewController

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.selectedIndices = [NSMutableIndexSet new];
    }
    
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerNib:[FUOnboardingAreaCollectionViewCell nib] forCellWithReuseIdentifier:[FUOnboardingAreaCollectionViewCell reuseIdentifier]];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];

    self.nextLabel.textColor = FUColorLightGray;
    self.arrowImageView.backgroundColor = FUColorOrange;
    self.arrowImageView.image = [UIImage imageNamed:@"double-arrow-down-white"];
    
    pageIndex++;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self updateFilterManager];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FUOnboardingAreaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FUOnboardingAreaCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    
    BOOL selected = [self.selectedIndices containsIndex:indexPath.row];
    NSString *imageName = [self imageNameAtIndexPath:indexPath];
    
    if (selected && imageName) {
        imageName = [imageName stringByAppendingString:@"-selected"];
    }

    cell.areaImageName = imageName;
    cell.areaName = [self titleAtIndexPath:indexPath];
    
    cell.selected = selected;

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;

    if ([self.selectedIndices containsIndex:index]) {
        [self.selectedIndices removeIndex:index];
    } else {
        [self.selectedIndices addIndex:index];
    }
    
    [self.collectionView reloadData];
}

- (NSString *)imageNameAtIndexPath:(NSIndexPath *)indexPath
{
    // Subclasses may override this method
    return nil;
}

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath
{
    // Subclasses may override this method
    return nil;
}

- (void)updateFilterManager
{
    NSMutableDictionary *allFilterItems = [[FUFilterManager sharedManager].filterItems mutableCopy];

    NSMutableDictionary *filters = [[allFilterItems objectForKey:self.filterKey] mutableCopy];

    NSMutableArray *titles = [NSMutableArray array];
    
    [self.selectedIndices enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        NSString *title = [self titleAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        
        if (title) {
            [filters setObject:@(YES) forKey:title];
            [titles addObject:title];
        }
    }];

    [allFilterItems setObject:filters forKey:self.filterKey];
    
    [[FUFilterManager sharedManager] saveAllFilterItems:allFilterItems];
    
    [[FUTrackingManager sharedManager] trackOnboardingResults:titles forScreenIndex:pageIndex];
}

@end
