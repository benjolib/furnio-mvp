//
//  FUProductDetailPageViewController.m
//  furn
//
//  Created by Stephan Krusche on 18/04/15.
//
//

#import "FUProductDetailPageViewController.h"
#import "FUProduct.h"

#import <UIImageView+WebCache.h>
#import "FUMacros.h"
#import "FUWishlistManager.h"
#import "FUProductManager.h"
#import "FUNumberFormatter.h"

@interface FUProductDetailPageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIScrollView *verticalScrollView;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageScrollViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageScrollViewHeightConstriant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceBottomSpaceConstraint;

@property (strong, nonatomic) NSMutableArray *imageViews;

@property (assign, nonatomic) BOOL detectLike;
@property (assign, nonatomic) BOOL detectDiscard;

@end

@implementation FUProductDetailPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    if(self.product == nil) {
        //no product is available any more
        //TODO: show different view
        return;
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
    //TODO open URL in browser view controller
}

- (IBAction)clickedClose:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickedReload:(id)sender {
    //TODO implement
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)loadNextProduct {
    [self setupView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.imageScrollView) {
        [self updatePage];
    }
    
    if (scrollView == self.verticalScrollView) {
//        NSLog(@"offset.y: %f", scrollView.contentOffset.y);
        if (scrollView.contentOffset.y < -50.0f) {
            self.detectLike = YES;
            self.detectDiscard = NO;
        }
        else if(scrollView.contentOffset.y > 50.0f) {
            self.detectDiscard = YES;
            self.detectLike = NO;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(self.detectLike == YES) {
        
        [[FUWishlistManager sharedManager] addProduct:self.product];
        self.product = [[FUProductManager sharedManager] nextProduct:self.product];
        [self loadNextProduct];
    }
    
    if(self.detectDiscard == YES) {
        FUProduct *newProduct = [[FUProductManager sharedManager] nextProduct:self.product];
        [[FUProductManager sharedManager] removeProduct:self.product];
        self.product = newProduct;
        [self loadNextProduct];
    }
}


@end
