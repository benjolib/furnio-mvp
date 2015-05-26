//
//  FUProductDetailFullscreenViewController.m
//  furn
//
//  Created by Stephan Krusche on 21/05/15.
//
//

#import "FUProductDetailFullscreenViewController.h"
#import "FUMacros.h"
#import <UIImageView+WebCache.h>

@interface FUProductDetailFullscreenViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) UIScrollView *mainScrollView;

@end

@implementation FUProductDetailFullscreenViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"PDP Fullscreen";
    
    self.view.frame = [UIScreen mainScreen].bounds;

    [self setupImagePages];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)setupImagePages {
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.delegate = self;
    
    CGRect innerScrollFrame = self.mainScrollView.bounds;
    CGRect visibleRect;
    
    for (int i = 0; i < [self.imageURLs count]; i++) {
        NSURL* imageUrl = self.imageURLs[i];
        UIImageView *imageForZooming = [[UIImageView alloc] init];
        imageForZooming.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [imageForZooming sd_setImageWithURL:imageUrl];
        imageForZooming.contentMode = UIViewContentModeScaleAspectFit;
        
        imageForZooming.tag = 1;
        
        UIScrollView *pageScrollView = [[UIScrollView alloc] initWithFrame:innerScrollFrame];
        pageScrollView.minimumZoomScale = 1.0f;
        pageScrollView.maximumZoomScale = 2.0f;
        pageScrollView.zoomScale = 1.0f;
        pageScrollView.contentSize = imageForZooming.bounds.size;
        pageScrollView.delegate = self;
        pageScrollView.showsHorizontalScrollIndicator = NO;
        pageScrollView.showsVerticalScrollIndicator = NO;
        [pageScrollView addSubview:imageForZooming];
        
        [self.mainScrollView addSubview:pageScrollView];
    
        if(i == self.selectedImageIndex) {
            visibleRect = innerScrollFrame;
        }
        
        if(i < [self.imageURLs count] - 1) {
            innerScrollFrame.origin.x += innerScrollFrame.size.width;
        }
    }
    
    self.mainScrollView.contentSize = CGSizeMake(innerScrollFrame.origin.x + innerScrollFrame.size.width, self.mainScrollView.bounds.size.height);
    [self.mainScrollView scrollRectToVisible:visibleRect animated:NO];
    
    [self.view insertSubview:self.mainScrollView atIndex:0];
    
    self.pageControl.currentPage = self.selectedImageIndex;
    self.pageControl.numberOfPages = [self.imageURLs count];
    
    if ([self.imageURLs count] == 1) {
        self.pageControl.hidden = YES;
        self.pageControl.enabled = NO;
    }
    else {
        self.pageControl.hidden = NO;
        self.pageControl.enabled = YES;
    }
}

- (void)updatePage {
    CGFloat pageWidth = self.mainScrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.mainScrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    self.pageControl.currentPage = page;
    self.selectedImageIndex = page;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mainScrollView) {
        [self updatePage];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:1];
}

@end
