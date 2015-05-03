//
//  FUOnboardingOverviewAreaCollectionViewCell.h
//  furn
//
//  Created by Markus Bösch on 03/05/15.
//
//

#import <UIKit/UIKit.h>

@interface FUOnboardingOverviewAreaCollectionViewCell : UICollectionViewCell

@property (assign, nonatomic, getter=isDone) BOOL done;

@property (strong, nonatomic) NSString *areaName;

+ (UINib *)nib;

+ (NSString *)reuseIdentifier;

+ (CGFloat)height;

@end
