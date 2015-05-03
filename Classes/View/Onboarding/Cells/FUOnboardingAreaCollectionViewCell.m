//
//  FUOnboardingAreaCollectionViewCell.m
//  furn
//
//  Created by Markus Bösch on 03/05/15.
//
//

#import "FUOnboardingAreaCollectionViewCell.h"

#import "FUColorConstants.h"

static NSString *const FUOnboardingAreaCollectionViewCellReuseIdentifier = @"FUOnboardingAreaCollectionViewCellReuseIdentifier";

@interface FUOnboardingAreaCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *areaImageView;

@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@end

@implementation FUOnboardingAreaCollectionViewCell

#pragma mark - Setter

- (void)setAreaImageName:(NSString *)areaImageName
{
    if (areaImageName) {
        self.areaImageView.image = [UIImage imageNamed:areaImageName];
    } else {
        self.areaImageView.image = nil;
    }
}

- (void)setAreaName:(NSString *)areaName
{
    self.areaLabel.text = areaName;
}

- (void)setSelected:(BOOL)selected
{
    self.areaLabel.textColor = selected ? FUColorOrange : FUColorLightGray;
}

#pragma mark - Static

+ (NSString *)reuseIdentifier
{
    return FUOnboardingAreaCollectionViewCellReuseIdentifier;
}

+ (CGFloat)height
{
    return 96;
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

@end
