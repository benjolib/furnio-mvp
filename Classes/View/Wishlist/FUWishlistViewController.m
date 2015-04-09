//
//  FUWishlistViewController.m
//  furn
//
//  Created by Markus Bösch on 09/04/15.
//
//

#import "FUWishlistViewController.h"

#import "UIView+FUAnimations.h"

@interface FUWishlistViewController ()

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (nonatomic, assign) FUWishlistViewState viewState;


@end

@implementation FUWishlistViewController


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewState = FUWishlistViewStateNormal;
}

#pragma mark - Actions

- (IBAction)closeButtonTapped:(UIButton *)sender
{
    [sender animateScaling];

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editButtonTapped:(UIButton *)sender
{
    // TODO: Add edit functionality
    
    [sender animateScaling];

    [self toggleViewState];
}


#pragma mark - Setter

- (void)setViewState:(FUWishlistViewState)viewState
{
    _viewState = viewState;
    
    NSString *imageName = viewState == FUWishlistViewStateNormal ? @"edit" : @"check-arrow";
    
    [self.editButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

#pragma mark - Private

- (void)toggleViewState
{
    if (self.viewState == FUWishlistViewStateNormal) {
        self.viewState = FUWishlistViewStateEdit;
    } else {
        self.viewState = FUWishlistViewStateNormal;
    }
}

@end
