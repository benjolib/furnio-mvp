//
//  FUOnboardingAreaViewController.h
//  furn
//
//  Created by Markus Bösch on 03/05/15.
//
//

#import "FUOnboardingBaseViewController.h"

#import "FUFilterManager.h"

@interface FUOnboardingAreaViewController : FUOnboardingBaseViewController

- (NSString *)imageNameAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic, readonly) NSMutableIndexSet *selectedIndices;

@property (copy, nonatomic) NSString *filterKey;

@end
