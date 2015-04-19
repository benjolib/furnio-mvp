//
//  FUSearchViewController.m
//  furn
//
//  Created by Markus Bösch on 19/04/15.
//
//

#import "FUSearchViewController.h"

#import "FUSearchTextField.h"

@interface FUSearchViewController ()

@property (weak, nonatomic) IBOutlet FUSearchTextField *searchTextField;

@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@end

@implementation FUSearchViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.view bringSubviewToFront:self.searchTextField];
    [self.view bringSubviewToFront:self.clearButton];
    
    [self.searchTextField becomeFirstResponder];
}

#pragma mark - FUViewController

- (void)configureNavigationBar
{
    self.navigationBar.leftButton = [self.navigationBar newBackButton];
}

#pragma mark - Actions

- (IBAction)clearButtonTapped:(id)sender
{
    self.searchTextField.text = @"";
}

@end
