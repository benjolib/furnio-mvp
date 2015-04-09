//
//  FUCollectionView.h
//  furn
//
//  Created by Markus Bösch on 29/03/15.
//
//

#import <UIKit/UIKit.h>

@class FUCollectionView;
@class FUProduct;

typedef NS_ENUM(NSInteger, FUCollectionViewMode)
{
    FUCollectionViewModeMatrix,
    FUCollectionViewModeGrid
};

@protocol FUCollectionViewDelegate <NSObject>

- (void)collectionView:(FUCollectionView *)collectionView didSelectProduct:(FUProduct *)product atIndex:(NSInteger)index;

@end

@interface FUCollectionView : UICollectionView

@property (assign, nonatomic, readonly) FUCollectionViewMode viewMode;

@property (weak, nonatomic) id<FUCollectionViewDelegate>furnCollectionDelegate;

- (void)toggleViewMode;

- (void)scrollToCenterAnimated:(BOOL)animated;

@end
