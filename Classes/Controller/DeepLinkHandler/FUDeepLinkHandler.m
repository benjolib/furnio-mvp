//
//  FUDeepLinkHandler.m
//  furn
//
//  Created by Markus Bösch on 07/04/15.
//
//

#import "FUDeepLinkHandler.h"

#import <DeepLinkSDK.h>

NSString *const FUDeepLinkHandlerErrorDomain = @"FUDeepLinkHandlerErrorDomain";

@interface FUDeepLinkHandler ()

@property (strong, nonatomic) DPLDeepLinkRouter *router;

@property (copy, nonatomic) NSString *urlScheme;

@end


@implementation FUDeepLinkHandler

#pragma mark - Initialization

+ (void)setupWithURLScheme:(NSString *)urlScheme
{
    NSAssert(urlScheme.length > 0, @"Please specify proper URL scheme for deep linking.");

    FUDeepLinkHandler *deeplinkHandler = [self sharedHandler];
    deeplinkHandler.urlScheme = urlScheme;
}

+ (instancetype)sharedHandler
{
    static FUDeepLinkHandler *handler;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [FUDeepLinkHandler new];
    });
    
    return handler;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.router = [DPLDeepLinkRouter new];
        
        [self setupRoutes];
    }

    return self;
}

#pragma mark - Public

- (void)handleURL:(NSURL *)url completion:(void (^)(BOOL handled, NSError *error))completion
{
    if (![self canHandleSchemeFromURL:url]) {
        if (completion) {
            completion(NO, [self errorForMismatchingURLScheme]);
            return;
        }
    }

    [self.router handleURL:url withCompletion:completion];
}

- (BOOL)canHandleSchemeFromURL:(NSURL *)url
{
    NSAssert(self.urlScheme.length > 0, @"Please specify proper URL scheme for deep linking before handling URLs.");

    return [url.scheme isEqualToString:self.urlScheme];
}

#pragma mark - Private

- (void)setupRoutes
{
    self.router[@"search?:q"] = ^(DPLDeepLink *deepLink) {
        NSLog(@"Searching for %@", deepLink.queryParameters[@"q"]);
    };
}

- (NSError *)errorForMismatchingURLScheme
{
    NSString *reason = [NSString stringWithFormat:@"FUDeepLinkHandler didn't recognize URL scheme. Expected: %@", self.urlScheme];
    
    return [NSError errorWithDomain:FUDeepLinkHandlerErrorDomain code:FUDeepLinkHandlerErrorCodeWrongScheme userInfo:@{ NSLocalizedDescriptionKey : reason }];
}

@end
