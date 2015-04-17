//
//  FUWishlistCollectionViewCell.h
//  furn
//
//  Created by Markus Bösch on 10/04/15.
//
//

#import <UIKit/UIKit.h>

@class FUProduct;
@class FUWishlistCollectionViewCell;
@class FUWishlistActionButton;

typedef NS_ENUM(NSInteger, FUWishlistViewState) {
    FUWishlistViewStateNormal,
    FUWishlistViewStateEdit
};

extern NSString *const FUWishlistCollectionViewCellReuseIdentifier;

@protocol FUWishlistCollectionViewCellDelegate <NSObject>

- (void)wishlistCollectionViewCell:(FUWishlistCollectionViewCell *)wishlistCollectionViewCell didTapDeleteButtonWithProduct:(FUProduct *)product isSelected:(BOOL)selected;

- (void)wishlistCollectionViewCell:(FUWishlistCollectionViewCell *)wishlistCollectionViewCell didTapShareButtonWithProduct:(FUProduct *)product;

@end


@interface FUWishlistCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) FUProduct *product;

@property (assign, nonatomic) FUWishlistViewState viewState;

@property (weak, nonatomic) IBOutlet FUWishlistActionButton *deleteButton;

@property (weak, nonatomic) IBOutlet FUWishlistActionButton *shareButton;

@property (weak, nonatomic) id<FUWishlistCollectionViewCellDelegate>delegate;

+ (UINib *)nib;

@end
