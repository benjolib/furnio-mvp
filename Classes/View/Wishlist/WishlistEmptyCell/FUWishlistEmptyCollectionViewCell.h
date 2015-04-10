//
//  FUWishlistEmptyCollectionViewCell.h
//  furn
//
//  Created by Markus Bösch on 10/04/15.
//
//

#import <UIKit/UIKit.h>

extern NSString *const FUWishlistEmptyCollectionViewCellReuseIdentifier;

@protocol FUWishlistEmptyCollectionViewCellDelegate <NSObject>

- (void)didPressStartSwipingButton;

@end

@interface FUWishlistEmptyCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<FUWishlistEmptyCollectionViewCellDelegate> delegate;

+ (UINib *)nib;

@end
