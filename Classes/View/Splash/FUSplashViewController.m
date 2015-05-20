//
//  FUSplashViewController.m
//  furn
//
//  Created by Stephan Krusche on 08/05/15.
//
//

#import "FUSplashViewController.h"
#import "FUColorConstants.h"
@import MediaPlayer;

#import <ADTransitionController.h>
#import <FXBlurView.h>

@interface FUSplashViewController ()

@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIView *blurViewImage;
@property (weak, nonatomic) IBOutlet UIView *blurViewButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *personalizeButton;

@property (strong, nonatomic) ADTransitioningDelegate *transitioningDelegate;

@end

@implementation FUSplashViewController

- (void)configureNavigationBar
{
    self.navigationBar.leftButton = nil;
}

- (void)dealloc
{
    self.transitioningDelegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.personalizeButton.layer.borderWidth = 1.5f;
    self.personalizeButton.layer.borderColor = [[UIColor colorWithRed:244.0/255.0 green:170.0/255.0 blue:56.0/255.0 alpha:1.0] CGColor];
    
    self.personalizeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
//    self.blurViewImage.blurRadius = 40.0f;
//    self.blurViewImage.updateInterval = 0.1;
//    
//    self.blurViewButton.blurRadius = 40.0f;
//    self.blurViewButton.updateInterval = 0.1;
    
    [self setupTransition];
    
    self.screenName = @"Splash";
}

- (void)setupTransition
{
    ADTransition *transition = [[ADSwipeFadeTransition alloc] initWithDuration:0.5f orientation:ADTransitionBottomToTop sourceRect:self.view.bounds];
    self.transitioningDelegate = [[ADTransitioningDelegate alloc] initWithTransition:transition];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.logoImageView.hidden = YES;
    self.personalizeButton.hidden = YES;
    self.personalizeButton.enabled = NO;
    self.blurViewButton.hidden = YES;
    self.blurViewImage.hidden = YES;
    
    [super viewWillAppear:animated];
    self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:[[NSBundle mainBundle] URLForResource:@"intro" withExtension:@"mp4"]];
    self.moviePlayerController.fullscreen = YES;
    self.moviePlayerController.controlStyle = MPMovieControlStyleNone;
    self.moviePlayerController.repeatMode = MPMovieRepeatModeOne;
    
    [self.moviePlayerController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.playerView addSubview:self.moviePlayerController.view];
    
    id views = @{ @"player": self.moviePlayerController.view };
    
    [self.playerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[player]|" options:0 metrics:nil views:views]];
    [self.playerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[player]|" options:0 metrics:nil views:views]];
    
    [self.moviePlayerController play];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performSelector:@selector(displayControls) withObject:nil afterDelay:5];
}

- (void)displayControls {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window)
    {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }

//    [window addSubview:self.blurViewImage];
//    [window addSubview:self.blurViewButton];
    [window addSubview:self.logoImageView];
    [window addSubview:self.personalizeButton];
    self.personalizeButton.enabled = YES;
    
    [UIView animateWithDuration:1.0 animations:^{
//        self.blurViewButton.hidden = YES;
//        self.blurViewImage.hidden = YES;
        self.logoImageView.hidden = NO;
        self.personalizeButton.hidden = NO;
    }];
}

- (IBAction)clickPersonalizeButton:(id)sender {
    
    [self.moviePlayerController stop];
    self.moviePlayerController = nil;
    
    [self.logoImageView removeFromSuperview];
    [self.personalizeButton removeFromSuperview];
    [self.blurViewButton removeFromSuperview];
    [self.blurViewImage removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
