//
//  FUOnboardingAreaCategoryViewController.m
//  furn
//
//  Created by Markus Bösch on 03/05/15.
//
//

#import "FUOnboardingAreaCategoryViewController.h"

#import "FUOnboardingAreaCollectionViewCell.h"

@interface FUOnboardingAreaCategoryViewController ()

@end

@implementation FUOnboardingAreaCategoryViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nextLabel.text = @"NEXT STEP: CHOOSING YOUR STYLE";
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat correctionOffset = [UIScreen mainScreen].bounds.size.height < 568 ? 7 : 0;
    
    return CGSizeMake(self.collectionView.width / 2, (self.collectionView.height / 4) - self.nextLabel.height + correctionOffset) ;
}

- (NSString *)imageNameAtIndexPath:(NSIndexPath *)indexPath
{
    static NSArray *imageNameArray;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageNameArray = @[
           @"sofa", @"watering-can",
           @"img-frame", @"brush",
           @"pram", @"oven",
           @"bath", @"lamp"
        ];
    });
    
    NSString *imageName;
    
    if (indexPath.row < imageNameArray.count) {
        imageName = [imageNameArray objectAtIndex:indexPath.row];
    }
    
    return imageName;
}

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath
{
    static NSArray *titleArray;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        titleArray = @[
            @"Furniture", @"Outdoor Products",
            @"Home Improvement", @"Home Decor",
            @"Baby & Kids", @"Kitchen & Dining",
            @"Bed & Bath", @"Lighting"
        ];
    });
    
    NSString *title;
    
    if (indexPath.row < titleArray.count) {
        title = [titleArray objectAtIndex:indexPath.row];
    }

    return title;
}

@end
