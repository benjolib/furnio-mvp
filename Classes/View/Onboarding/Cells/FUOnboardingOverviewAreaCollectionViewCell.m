//
//  FUOnboardingOverviewAreaCollectionViewCell.m
//  furn
//
//  Created by Markus Bösch on 03/05/15.
//
//

#import "FUOnboardingOverviewAreaCollectionViewCell.h"

static NSString *const FUOnboardingOverviewAreaCollectionViewCellReuseIdentifier = @"FUOnboardingOverviewAreaCollectionViewCellReuseIdentifier";

@interface FUOnboardingOverviewAreaCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *heartButton;

@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@end

@implementation FUOnboardingOverviewAreaCollectionViewCell

#pragma mark - Setter

- (void)setDone:(BOOL)done
{
    if (_done == done) {
        return;
    }
    
    _done = done;
    
    NSString *imageName = done ? @"heart-filled" : @"heart-normal";
    
    self.heartButton.image = [UIImage imageNamed:imageName];
}

- (void)setAreaName:(NSString *)areaName
{
    self.areaLabel.text = areaName;
}

#pragma mark - Static

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

+ (NSString *)reuseIdentifier
{
    return FUOnboardingOverviewAreaCollectionViewCellReuseIdentifier;
}

+ (CGFloat)height
{
    return 72;
}

@end
