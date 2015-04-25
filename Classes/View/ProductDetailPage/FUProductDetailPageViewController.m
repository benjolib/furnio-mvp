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

#import <UIImageView+WebCache.h>
#import "FUMacros.h"
#import "FUWishlistManager.h"
#import "FUProductManager.h"
#import "FUNumberFormatter.h"
#import "FUProductAction.h"
#import "FUProductDetailBrowserViewController.h"

@interface FUProductDetailPageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *discardLabel;


@property (weak, nonatomic) IBOutlet UIButton *undoButton;

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIScrollView *verticalScrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageScrollViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageScrollViewHeightConstriant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceBottomSpaceConstraint;

@property (strong, nonatomic) NSMutableArray *imageViews;
@property (strong, nonatomic) NSMutableArray *actions;

@property (assign, nonatomic) BOOL detectLike;
@property (assign, nonatomic) BOOL detectDiscard;

@property (strong, nonatomic) UIView *noProductView;

@end

@implementation FUProductDetailPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.actions = [NSMutableArray array];
    
    CGRect frame = self.imageScrollView.frame;
    frame.size.width = DEVICE_WIDTH;
    frame.size.height = DEVICE_WIDTH;
    self.imageScrollView.frame = frame;
    
    self.imageScrollViewHeightConstriant.constant = DEVICE_WIDTH;
    self.imageScrollViewWidthConstraint.constant = DEVICE_WIDTH;
    
    CGFloat diff = (DEVICE_HEIGHT - 667) - (DEVICE_WIDTH - 375);
    
    self.priceTopSpaceConstraint.constant = 72 + diff / 2;
    self.priceBottomSpaceConstraint.constant = 33 + diff / 2;
    
    NSLog(@"diff: %f", diff);
    NSLog(@"priceTopSpaceConstraint: %f", self.priceTopSpaceConstraint.constant);
    NSLog(@"priceTopSpaceConstraint: %f", self.priceBottomSpaceConstraint.constant);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupView];
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
        self.verticalScrollView.scrollEnabled = YES;
        [self.noProductView removeFromSuperview];
    }
    
    
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
    
    for(NSURL* imageUrl in self.product.imageURLs) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:imageUrl];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        CGRect frame = self.imageScrollView.bounds;
        frame.origin.x = frame.size.width * pageIndex;
        frame.origin.y = 0.0f;
        
        imageView.frame = frame;
        
        [self.imageViews addObject:imageView];
        [self.imageScrollView addSubview:imageView];
        pageIndex++;
    }
    
    for(NSURL* imageUrl in self.product.imageURLs) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:imageUrl];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        CGRect frame = self.imageScrollView.bounds;
        frame.origin.x = frame.size.width * pageIndex;
        frame.origin.y = 0.0f;
        
        imageView.frame = frame;
        
        [self.imageViews addObject:imageView];
        [self.imageScrollView addSubview:imageView];
        pageIndex++;
    }
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.imageViews.count;

    
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
    
    [self.navigationController pushViewController:productBrowserViewController animated:YES];
}

- (IBAction)clickedClose:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickedUndo:(id)sender {
    
    FUProductAction *lastAction = [self.actions lastObject];
    if (lastAction) {
        [self.actions removeObject:lastAction];
        [lastAction undo];
        self.product = lastAction.product;
        [self loadProduct];
        //TODO: animation is missing
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
//        NSLog(@"offset.y: %f", scrollView.contentOffset.y);
        
        if (scrollView.contentOffset.y < -20.0f) {
            self.likeLabel.hidden = YES;
            self.detectLike = YES;
        }
        else {
            self.likeLabel.hidden = NO;
            self.detectLike = NO;
        }
        
        if(scrollView.contentOffset.y > 20.0f) {
            self.discardLabel.hidden = YES;
            self.detectDiscard = YES;
        }
        else {
            self.discardLabel.hidden = NO;
            self.detectDiscard = NO;
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

- (void) animateAction:(FUActionType)actionType {
    
    CGFloat targetHeight = actionType == FUActionTypeLike ? DEVICE_HEIGHT : -DEVICE_HEIGHT;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    imageView.image = [self makeImage];
    [self.view addSubview:imageView];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        CGRect frame = imageView.frame;
        frame.origin.y = targetHeight;
        imageView.frame = frame;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    FUActionType actionType;
    
    if(self.detectLike == YES) {
        actionType = FUActionTypeLike;
    }
    else if(self.detectDiscard == YES) {
        actionType = FUActionTypeDiscard;
    }
    else {
        return;
    }
    
    FUProductAction *action = [[FUProductAction alloc] initWithProduct:self.product action:actionType];
    [self.actions addObject:action];
    [action execute];
    
    [self animateAction:action.actionType];
    
    self.product = [[FUProductManager sharedManager] nextProduct:self.product];
    [self loadProduct];
}



@end
