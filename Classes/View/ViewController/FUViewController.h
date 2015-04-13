//
//  ViewController.h
//  furn
//
//  Created by Markus Bösch on 29/03/15.
//
//

#import <UIKit/UIKit.h>

#import "FUNavigationBar.h"

@interface FUViewController : UIViewController

@property (strong, nonatomic) FUNavigationBar *navigationBar;

- (void)configureNavigationBar;

@end

