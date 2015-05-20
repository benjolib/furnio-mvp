//
//  ViewController.h
//  furn
//
//  Created by Markus Bösch on 29/03/15.
//
//

#import <UIKit/UIKit.h>

#import "FUNavigationBar.h"
#import "FULoadingViewManager.h"

#import <GAI.h>

@interface FUViewController : GAITrackedViewController

@property (strong, nonatomic) FUNavigationBar *navigationBar;

- (void)configureNavigationBar;

- (void)configureLoadingView;

@end
