//
//  FUProductDetailBrowserViewController.m
//  furn
//
//  Created by Stephan Krusche on 25/04/15.
//
//

#import "FUProductDetailBrowserViewController.h"
#import "FUProduct.h"
#import "FUSharingManager.h"
#import "FUSeller.h"
#import "FULoadingViewManager.h"

@interface FUProductDetailBrowserViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationTitle;

@end

@implementation FUProductDetailBrowserViewController

#pragma mark - Initialization

- (void)dealloc
{
    self.webView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle.title = self.product.seller.name;
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.product.productURL]];
    
    self.screenName = @"PDP Browser";
    
    self.webView.delegate = self;
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [FULoadingViewManager sharedManger].text = @"Loading";
    [FULoadingViewManager sharedManger].hideShadowBackground = YES;
    [FULoadingViewManager sharedManger].allowLoadingView = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [FULoadingViewManager sharedManger].text = @"LOADING PRODUCTS";
    [FULoadingViewManager sharedManger].hideShadowBackground = NO;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Actions

- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)share:(id)sender {
    [FUSharingManager shareProduct:self.product withViewController:self completion:^(BOOL success) {
        NSLog(@"Sharing finished!");
    }];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}

@end
