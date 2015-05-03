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
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FUOnboardingAreaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FUOnboardingAreaCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    
    cell.areaImageName = [self imageNameAtIndexPath:indexPath];
    cell.areaName = [self titleAtIndexPath:indexPath];
    
    cell.selected = [self.selectedIndices containsIndex:indexPath.row];

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

@end
