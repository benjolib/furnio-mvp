//
//  FUFilterPriceViewController.m
//  furn
//
//  Created by Stephan Krusche on 26/04/15.
//
//

#import "FUFilterPriceViewController.h"

@interface FUFilterPriceViewController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@end

@implementation FUFilterPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //TODO: border around filter button
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
    
    self.navItem.title = self.name;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)applyFilter:(id)sender {
    //TODO
}

- (IBAction)removeFilter:(id)sender {
    //TODO
}

- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
