//
//  FUCatalogEmptyCollectionViewCell.h
//  furn
//
//  Created by Markus Bösch on 17/04/15.
//
//

#import <UIKit/UIKit.h>

extern NSString *const FUCatalogEmptyCollectionViewCellReuseIdentifier;

@protocol FUCatalogEmptyCollectionViewCellDelegate <NSObject>

- (void)didTapResetButton;

@end

@interface FUCatalogEmptyCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<FUCatalogEmptyCollectionViewCellDelegate>delegate;

+ (UINib *)nib;

@end
