//
//  FUOnboardingOverviewTextCollectionViewCell.m
//  furn
//
//  Created by Markus Bösch on 03/05/15.
//
//

#import "FUOnboardingOverviewTextCollectionViewCell.h"

static NSString *const FUOnboardingOverviewTextCollectionViewCellReuseIdentifier = @"FUOnboardingOverviewTextCollectionViewCellReuseIdentifier";


@implementation FUOnboardingOverviewTextCollectionViewCell


#pragma mark - Static

+ (NSString *)reuseIdentifier;
{
    return FUOnboardingOverviewTextCollectionViewCellReuseIdentifier;
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

+ (CGFloat)height
{
    return 250;
}

@end
