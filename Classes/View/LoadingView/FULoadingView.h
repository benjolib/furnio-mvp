//
//  FULoadingView.h
//  furn
//
//  Created by Markus Bösch on 17/04/15.
//
//

#import <UIKit/UIKit.h>

#import <MMMaterialDesignSpinner.h>

@interface FULoadingView : UIView

@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;

@property (weak, nonatomic) IBOutlet MMMaterialDesignSpinner *activityIndicatorView;

- (void)showAnimated:(BOOL)animated;

- (void)hideAnimated:(BOOL)animated;

@end
