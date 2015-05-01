//
//  FULoadingViewManager.m
//  furn
//
//  Created by Markus Bösch on 17/04/15.
//
//

#import "FULoadingViewManager.h"

#import "FULoadingView.h"
#import "FUAppirater.h"

#import <UIKit/UIKit.h>

static NSString *const FULoadingViewManagerIndicatorKeyPath = @"networkActivityIndicatorVisible";

@interface FULoadingViewManager ()

@property (strong, nonatomic) FULoadingView *loadingView;

@property (assign, nonatomic) BOOL isLoading;

@end


@implementation FULoadingViewManager

#pragma mark - Initialization

- (void)dealloc
{
    [[UIApplication sharedApplication] removeObserver:self forKeyPath:FULoadingViewManagerIndicatorKeyPath];
}

+ (instancetype)sharedManger
{
    static FULoadingViewManager *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [FULoadingViewManager new];
    });
    
    return instance;
}

+ (void)setup
{
    [self sharedManger];
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self setupObservers];
    }

    return self;
}

#pragma mark - Setters

- (void)showLoadingViewWithText:(NSString *)text
{
    if (self.loadingView) {
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
    }
    
    self.loadingView = [[FULoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.loadingView.loadingLabel.text = text;
    
    [self.loadingView showAnimated:YES];
}

- (void)hideLoadingView
{
    [self.loadingView hideAnimated:NO];
    
    self.loadingView = nil;
}

- (void)setAllowLoadingView:(BOOL)allowLoadingView
{
    _allowLoadingView = allowLoadingView;
    
    if (!allowLoadingView && self.loadingView) {
        [self hideLoadingView];
    }
}

- (void)setIsLoading:(BOOL)isLoading
{
    if (_isLoading == isLoading) {
        return;
    }

    _isLoading = isLoading;

    if (isLoading && self.allowLoadingView) {
        [self showLoadingViewWithText:self.text];
    } else {
        [self hideLoadingView];
    }
}

#pragma mark - KVO

- (void)setupObservers
{
    [[UIApplication sharedApplication] addObserver:self forKeyPath:FULoadingViewManagerIndicatorKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == [UIApplication sharedApplication] && [keyPath isEqualToString:FULoadingViewManagerIndicatorKeyPath]) {
        self.isLoading = [change[@"new"] boolValue];
    }
}

@end
