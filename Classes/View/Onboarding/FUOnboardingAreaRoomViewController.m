//
//  FUOnboardingAreaRoomViewController.m
//  furn
//
//  Created by Markus Bösch on 03/05/15.
//
//

#import "FUOnboardingAreaRoomViewController.h"

#import "FUActionButton.h"

@interface FUOnboardingAreaRoomViewController ()

@end


@implementation FUOnboardingAreaRoomViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nextLabel.hidden = YES;
    self.arrowImageView.hidden = YES;

    self.startButton.hidden = NO;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.width / 2, (self.collectionView.height / 4) - self.nextLabel.height) ;
}

- (NSString *)imageNameAtIndexPath:(NSIndexPath *)indexPath
{
    static NSArray *imageNameArray;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageNameArray = @[
           @"oven", @"bath",
           @"bed", @"couch",
           @"dish", @"pram",
           @"watering-can", @"laptop"
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
            @"Kitchen", @"Bath",
            @"Bedroom", @"Living",
            @"Dining", @"Kids",
            @"Outdoor", @"Office"
        ];
    });

    NSString *title;
    
    if (indexPath.row < titleArray.count) {
        title = [titleArray objectAtIndex:indexPath.row];
    }
    
    return title;
}

@end
