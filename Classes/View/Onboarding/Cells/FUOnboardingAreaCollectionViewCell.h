//
//  FUOnboardingAreaCollectionViewCell.h
//  furn
//
//  Created by Markus Bösch on 03/05/15.
//
//

#import <UIKit/UIKit.h>

@interface FUOnboardingAreaCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSString *areaImageName;

@property (strong, nonatomic) NSString *areaName;

+ (UINib *)nib;

+ (NSString *)reuseIdentifier;

+ (CGFloat)height;

@end
