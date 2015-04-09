//
//  FUDeepLinkHandler.h
//  furn
//
//  Created by Markus Bösch on 07/04/15.
//
//

#import <Foundation/Foundation.h>

extern NSString *const FUDeepLinkHandlerErrorDomain;

typedef NS_ENUM(NSInteger, FUDeepLinkHandlerErrorCode) {
    FUDeepLinkHandlerErrorCodeWrongScheme
};

@class DPLDeepLinkRouter;

@interface FUDeepLinkHandler : NSObject

@property (strong, nonatomic, readonly) DPLDeepLinkRouter *router;

@property (copy, nonatomic, readonly) NSString *urlScheme;

+ (void)setupWithURLScheme:(NSString *)urlScheme;

+ (instancetype)sharedHandler;

- (void)handleURL:(NSURL *)url completion:(void (^)(BOOL handled, NSError *error))completion;

- (BOOL)canHandleSchemeFromURL:(NSURL *)url;

@end
