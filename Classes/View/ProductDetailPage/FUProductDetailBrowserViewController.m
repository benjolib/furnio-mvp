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
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.product.houzzURL]];
}

- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)share:(id)sender {
    [FUSharingManager shareProduct:self.product withViewController:self completion:^{
        NSLog(@"Sharing finished!");
    }];
    
//    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[self.product.houzzURL] applicationActivities:nil];
//    [self presentViewController:controller animated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
