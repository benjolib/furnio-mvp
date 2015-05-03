//
//  FUOnboardingBaseViewController.h
//  furn
//
//  Created by Markus Bösch on 02/05/15.
//
//

#import "FUViewController.h"

#import "UIView+Framing.h"

@class FUActionButton;

@interface FUOnboardingBaseViewController : FUViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *nextLabel;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (weak, nonatomic) IBOutlet FUActionButton *startButton;

@end
