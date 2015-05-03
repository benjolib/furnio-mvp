//
//  FUProductDetailPageViewController.m
//  furn
//
//  Created by Stephan Krusche on 18/04/15.
//
//

#import <QuartzCore/QuartzCore.h>

#import "FUProductDetailPageViewController.h"
#import "FUProduct.h"
#import "FUColorConstants.h"

#import <UIImageView+WebCache.h>
#import "FUMacros.h"
#import "FUWishlistManager.h"
#import "FUProductManager.h"
#import "FUNumberFormatter.h"
#import "FUProductAction.h"
#import "FUProductDetailBrowserViewController.h"
#import "FUTrackingManager.h"

#define FUProductDetailTutorialShown @"FUProductDetailTutorialShown"


@interface FUProductDetailPageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *discardLabel;

@property (weak, nonatomic) IBOutlet UIView *likeContainer;
@property (weak, nonatomic) IBOutlet UIView *discardContainer;

@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIScrollView *verticalScrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageScrollViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageScrollViewHeightConstriant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceBottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewLeadingSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTrailingSpace;

@property (strong, nonatomic) NSMutableArray *imageViews;
@property (strong, nonatomic) NSMutableArray *actions;

@property (assign, nonatomic) BOOL detectLike;
@property (assign, nonatomic) BOOL detectDiscard;
@property (assign, nonatomic, getter=isSingleProduct) BOOL singleProduct;

@property (strong, nonatomic) UIView *noProductView;

@property (strong, nonatomic) UIImageView *tutorialView1;
@property (strong, nonatomic) UIImageView *tutorialView2;
@property (strong, nonatomic) UIImageView *tutorialView3;

@property (assign, nonatomic) NSUInteger tutorialTapCount;

@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@end

@implementation FUProductDetailPageViewController

#pragma mark - Initialization

- (instancetype)initWithSingleProduct:(FUProduct *)product
{
    self = [super init];
    
    if (self) {
        self.product = product;
        self.singleProduct = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.actions = [NSMutableArray array];

    CGRect frame = self.imageScrollView.frame;
    CGFloat diff;
    
    if(DEVICE_HEIGHT > 480) {
        //iPhone 5(s) or larger
        frame.size.width = DEVICE_WIDTH;
        frame.size.height = DEVICE_WIDTH;
        diff = (DEVICE_HEIGHT - 667) - (DEVICE_WIDTH - 375);
    }
    else {
        //iPhone 4(s)
        frame.size.width = DEVICE_WIDTH - 60;
        frame.size.height = DEVICE_WIDTH - 60;
        frame.origin.x = 30;
        
        diff = (DEVICE_HEIGHT - 667) - (DEVICE_WIDTH - 375) + 60;
    }
    self.imageScrollViewHeightConstriant.constant = frame.size.height;
    self.imageScrollViewWidthConstraint.constant = frame.size.width;
    self.scrollViewLeadingSpace.constant = frame.origin.x;
    self.scrollViewTrailingSpace.constant = frame.origin.x;
    self.imageScrollView.frame = frame;
    
    self.priceTopSpaceConstraint.constant = 72 + diff * (2.0 / 3.0);
    self.priceBottomSpaceConstraint.constant = 33 + diff * (1.0 / 3.0);
    
    [self updateSingleProductState];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupView];
    
    BOOL tutorialShown = [[NSUserDefaults standardUserDefaults] boolForKey:FUProductDetailTutorialShown];
    if(!tutorialShown) {
        [self showTutorial];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FUProductDetailTutorialShown];
    }
}

- (void) showTutorial {
    self.verticalScrollView.scrollEnabled = NO;
    self.buyButton.enabled = NO;
    self.closeButton.enabled = NO;
    self.undoButton.enabled = NO;
    
    self.imageScrollView.scrollEnabled = NO;
    self.tutorialView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    self.tutorialView1.image = [UIImage imageNamed:@"pdp-tutorial1"];
    self.tutorialView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    self.tutorialView2.image = [UIImage imageNamed:@"pdp-tutorial2"];
    self.tutorialView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    self.tutorialView3.image = [UIImage imageNamed:@"pdp-tutorial3"];
    [self.view addSubview:self.tutorialView3];
    [self.view addSubview:self.tutorialView2];
    [self.view addSubview:self.tutorialView1];
    self.tutorialTapCount = 3;
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tutorialTap:)];
    self.tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.tapRecognizer];
}

- (void)tutorialTap:(UIGestureRecognizer *)gestureRecognizer {
    
    CGPoint location = [gestureRecognizer locationInView:self.view];
 
    if(!CGRectContainsPoint(CGRectMake(0, (480.0 / 667.0) * DEVICE_HEIGHT, DEVICE_WIDTH, (80.0 / 667.0) * DEVICE_HEIGHT), location)) {
        return;
    }
    
    UIImageView *viewToRemove;
    if(self.tutorialTapCount == 3) {
        viewToRemove = self.tutorialView1;
    }
    if(self.tutorialTapCount == 2) {
        viewToRemove = self.tutorialView2;
    }
    if(self.tutorialTapCount == 1) {
        viewToRemove = self.tutorialView3;
        [self.view removeGestureRecognizer:self.tapRecognizer];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = viewToRemove.frame;
        frame.origin.x = -DEVICE_WIDTH;
        viewToRemove.frame = frame;
    } completion:^(BOOL finished) {
        [viewToRemove removeFromSuperview];
        
        self.buyButton.enabled = YES;
        self.closeButton.enabled = YES;
        
        [self setupView];
        
    }];

    self.tutorialTapCount--;
}

- (void)setupView {
    
    if(self.product == nil || [self.actions count] == 0) {
        self.undoButton.enabled = NO;
    }
    else {
        self.undoButton.enabled = YES;
    }
    
    if(self.product == nil) {
        
        // Instantiate the nib content without any reference to it.
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"FUNoProductView" owner:nil options:nil];
        
        // Find the view among nib contents (not too hard assuming there is only one view in it).
        self.noProductView = [nibContents lastObject];
        self.noProductView.frame = CGRectMake(0, 60, DEVICE_WIDTH, DEVICE_HEIGHT - 50 - 20);
        
        UIButton *goBackButton;
        
        for(UIView *subView in self.noProductView.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                goBackButton = (UIButton *)subView;
            }
        }
        
        goBackButton.layer.borderWidth = 1.5f;
        goBackButton.layer.borderColor = [[UIColor colorWithRed:244.0/255.0 green:170.0/255.0 blue:56.0/255.0 alpha:1.0] CGColor];
        [goBackButton addTarget:self action:@selector(clickedClose:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.noProductView];
        
        self.verticalScrollView.scrollEnabled = NO;
        
        NSLog(@"No product left!!");
        return;
    }
    else {
        self.verticalScrollView.scrollEnabled = !self.isSingleProduct;
        [self.noProductView removeFromSuperview];
    }
    
    self.likeContainer.backgroundColor = FUColorOrange;
    self.discardContainer.backgroundColor = FUColorLightGray;
    self.detectDiscard = NO;
    self.detectLike = NO;
    
    self.imageViews = [NSMutableArray array];
    self.productNameLabel.text = self.product.name;
    self.priceLabel.text = [[FUNumberFormatter currencyNumberFormatter] stringFromNumber:self.product.price];
    self.brandNameLabel.text = self.product.properties.manufacturer;
    self.styleNameLabel.text = self.product.properties.designer;

    [self setupImagePages];
}

- (void)setupImagePages {
    
    for(UIView *view in self.imageScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    NSUInteger pageIndex = 0;
    for(NSURL* imageUrl in self.product.imageURLs) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:imageUrl];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        CGRect frame = self.imageScrollView.frame;
        frame.origin.x = DEVICE_WIDTH * pageIndex;
        frame.origin.y = 0.0f;
        
        imageView.frame = frame;
        
        [self.imageViews addObject:imageView];
        [self.imageScrollView addSubview:imageView];
        pageIndex++;
    }
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = [self.imageViews count];

    if([self.imageViews count] == 1) {
        self.pageControl.hidden = YES;
        self.imageScrollView.bounces = NO;
        self.imageScrollView.scrollEnabled = NO;
    }
    else {
        self.pageControl.hidden = NO;
        self.imageScrollView.bounces = YES;
        self.imageScrollView.scrollEnabled = NO;
    }
    
    CGSize pagesScrollViewSize = self.imageScrollView.frame.size;
    self.imageScrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.imageViews.count, pagesScrollViewSize.height);
}

- (void)updatePage {
    CGFloat pageWidth = self.imageScrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.imageScrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    self.pageControl.currentPage = page;
}

- (IBAction)clickedBuy:(id)sender {
    FUProductDetailBrowserViewController *productBrowserViewController = [[FUProductDetailBrowserViewController alloc] init];
    productBrowserViewController.product = self.product;

    [[FUTrackingManager sharedManager] trackPDPBuyProduct:self.product];
    [self.navigationController pushViewController:productBrowserViewController animated:YES];
}

- (IBAction)clickedClose:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickedUndo:(id)sender {
    
    FUProductAction *lastAction = [self.actions lastObject];
    
    if (lastAction) {
        [self.actions removeObject:lastAction];
        UIImageView *imageView = lastAction.imageView;
        CGRect frame = imageView.frame;
        frame.origin.y = lastAction.actionType == FUActionTypeLike ? -DEVICE_HEIGHT : DEVICE_HEIGHT;
        imageView.frame = frame;
        [self.view addSubview:imageView];
        self.product = lastAction.product;
        
        [UIView animateWithDuration:1.0 animations:^{
            
            //animate image back to origin
            CGRect frame = imageView.frame;
            frame.origin.y = lastAction.yOffset;
            imageView.frame = frame;
        } completion:^(BOOL finished) {

            [lastAction undo];
            [imageView removeFromSuperview];
        }];
        
        [self performSelector:@selector(loadProduct) withObject:nil afterDelay:0.99];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)loadProduct {
    [self setupView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.imageScrollView) {
        [self updatePage];
    }
    
    if (scrollView == self.verticalScrollView) {
        
        if(scrollView.contentOffset.y < -20.0f) {
            self.likeLabel.hidden = YES;
            self.detectDiscard = YES;
            self.likeContainer.backgroundColor = FUColorLightGray;
        }
        else {
            self.likeLabel.hidden = NO;
            self.detectDiscard = NO;
            self.likeContainer.backgroundColor = FUColorOrange;
        }
        
        if (scrollView.contentOffset.y > 20.0f) {
            self.discardLabel.hidden = YES;
            self.detectLike = YES;
            self.discardContainer.backgroundColor = FUColorOrange;
        }
        else {
            self.discardLabel.hidden = NO;
            self.detectLike = NO;
            self.discardContainer.backgroundColor = FUColorLightGray;
        }
    }
}

-(UIImage*) makeImage {
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

- (void) animateAction:(FUProductAction *)action {
    
    CGFloat targetOrigin = action.actionType == FUActionTypeLike ? -DEVICE_HEIGHT : DEVICE_HEIGHT;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    imageView.image = [self makeImage];
    [self.view addSubview:imageView];
    
    [UIView animateWithDuration:1.0 animations:^{
        CGRect frame = imageView.frame;
        frame.origin.y = targetOrigin;
        imageView.frame = frame;
    } completion:^(BOOL finished) {
        action.imageView = imageView;
        [imageView removeFromSuperview];
    }];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    FUActionType actionType;
    
    if(self.detectLike == YES) {
        actionType = FUActionTypeLike;
        [[FUTrackingManager sharedManager] trackPDPLikeProduct:self.product];
    }
    else if(self.detectDiscard == YES) {
        actionType = FUActionTypeDiscard;
        [[FUTrackingManager sharedManager] trackPDPDislikeProduct:self.product];
    }
    else {
        return;
    }
    
    FUProductAction *action = [[FUProductAction alloc] initWithProduct:self.product action:actionType];
    action.yOffset = scrollView.contentOffset.y;
    [self.actions addObject:action];
    [action execute];
    
    [self animateAction:action];
    
    self.product = [[FUProductManager sharedManager] nextProduct:self.product];
    [self loadProduct];
}

#pragma mark - Private

- (void)updateSingleProductState
{
    self.verticalScrollView.scrollEnabled = !self.singleProduct;
    self.likeContainer.hidden = self.singleProduct;
    self.discardContainer.hidden = self.singleProduct;
    self.undoButton.hidden = self.singleProduct;
}

@end
