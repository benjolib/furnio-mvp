//
//  FUCatalogCollectionViewCell.h
//  furn
//
//  Created by Markus Bösch on 29/03/15.
//
//

#import <UIKit/UIKit.h>

#import "FUCollectionView.h"

@class FUProduct;

extern NSString *const FUCatalogCollectionViewCellReuseIdentifier;

@interface FUCatalogCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) FUProduct *product;

@property (assign, nonatomic) FUCollectionViewMode viewMode;

@end
