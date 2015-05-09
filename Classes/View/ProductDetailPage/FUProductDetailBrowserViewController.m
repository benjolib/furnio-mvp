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

@interface FUProductDetailBrowserViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationTitle;

@end

@implementation FUProductDetailBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle.title = self.product.seller.name;
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.product.seller.houzzURL]];
}

- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)share:(id)sender {
    [FUSharingManager shareProduct:self.product withViewController:self completion:^(BOOL success) {
        NSLog(@"Sharing finished!");
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
