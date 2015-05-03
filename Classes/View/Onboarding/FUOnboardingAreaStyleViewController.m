//
//  FUOnboardingAreaStyleViewController.m
//  furn
//
//  Created by Markus Bösch on 03/05/15.
//
//

#import "FUOnboardingAreaStyleViewController.h"

@interface FUOnboardingAreaStyleViewController ()

@end

@implementation FUOnboardingAreaStyleViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nextLabel.text = @"NEXT STEP: CHOOSING YOUR ROOMS";
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 14;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.width / 2, (self.collectionView.height / 7) - 10) ;
}

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath
{
    static NSArray *titleArray;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        titleArray = @[
           @"All", @"Contemporary",
           @"Eclectic", @"Modern",
           @"Traditional", @"Asian",
           @"Beach Style", @"Craftsman",
           @"Farmhouse", @"Industrial",
           @"Rustic", @"Southwestern",
           @"Transitional", @"Tropical"
        ];
    });

    NSString *title;
    
    if (indexPath.row < titleArray.count) {
        title = [titleArray objectAtIndex:indexPath.row];
    }
    
    return title;
}

@end
