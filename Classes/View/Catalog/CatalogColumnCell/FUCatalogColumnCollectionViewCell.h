//
//  FUCatalogColumnCollectionViewCell.h
//  furn
//
//  Created by Markus Bösch on 29/03/15.
//
//

#import <UIKit/UIKit.h>

#import "FUCollectionView.h"


@class FUCatalogColumnCollectionViewCell;
@class FUProduct;

@protocol FUCatalogColumnCollectionViewCellDelegate <NSObject>

- (void)columnCell:(FUCatalogColumnCollectionViewCell *)columnCell didSelectProduct:(FUProduct *)product atIndex:(NSInteger)index;

@end

extern NSString *const FUCatalogColumnCollectionViewCellReuseIdentifier;

extern NSString *const FUCatalogColumnCollectionViewCellScrollingDidStartNotification;
extern NSString *const FUCatalogColumnCollectionViewCellScrollingDidFinishNotification;

@interface FUCatalogColumnCollectionViewCell : UICollectionViewCell

@property (assign, nonatomic) NSUInteger columnIndex;

@property (weak, nonatomic) id<FUCatalogColumnCollectionViewCellDelegate>delegate;

@property (assign, nonatomic) FUCollectionViewMode viewMode;

@property (weak, nonatomic) IBOutlet UICollectionView *verticalCollectionView;

@end
