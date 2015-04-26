//
//  FUTrackingManager.m
//  furn
//
//  Created by Markus Bösch on 26/04/15.
//
//

#import "FUTrackingManager.h"

#import "FUProduct.h"
#import "FUSeller.h"
#import "FUProperties.h"
#import "FUCollectionView.h"
#import "NSMutableDictionary+Tracking.h"

#import <Adjust.h>

@implementation FUTrackingManager

#pragma mark - Initialization

+ (instancetype)sharedManager
{
    static FUTrackingManager *instance;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [FUTrackingManager new];
    });
    
    return instance;
}

#pragma mark - Tracking

- (void)trackRateApp
{
    [self trackEventWithToken:@"g90yjx"];
}

- (void)trackPDPBuyProduct:(FUProduct *)product
{
    [self trackEventWithToken:@"q5wegn" product:product];
}

- (void)trackPDPLikeProduct:(FUProduct *)product
{
    [self trackEventWithToken:@"4lb05e" product:product];
}

- (void)trackPDPDislikeProduct:(FUProduct *)product
{
    [self trackEventWithToken:@"g3a7ic" product:product];
}

- (void)trackPDPShareProduct:(FUProduct *)product
{
    [self trackEventWithToken:@"m1tao5" product:product];
}

- (void)trackWishlistRemoveProduct:(FUProduct *)product
{
    [self trackEventWithToken:@"o07ap9" product:product];
}

- (void)trackWishlistShareProduct:(FUProduct *)product
{
    [self trackEventWithToken:@"f9ygjy" product:product];
}

- (void)trackCatalogViewMode:(FUCollectionViewMode)viewMode
{
    [self trackEventWithToken:@"xlr8n5" viewMode:viewMode];
}

#pragma mark - Private

- (void)trackEventWithToken:(NSString *)token
{
    [self trackEventWithToken:token product:nil];
}

- (void)trackEventWithToken:(NSString *)token product:(FUProduct *)product
{
    [self trackEventWithToken:token product:product revenue:nil];
}

- (void)trackEventWithToken:(NSString *)token product:(FUProduct *)product revenue:(NSNumber *)revenue
{
    NSParameterAssert(token);

    ADJEvent *event = [ADJEvent eventWithEventToken:token];
    
    if (product) {
        NSMutableDictionary *callbackParameters = [self callbackParametersWithProduct:product];
        
        [callbackParameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            [event addCallbackParameter:key value:value];
        }];
    }
    
    if (revenue && revenue.doubleValue > 0) {
        [event setRevenue:revenue.doubleValue currency:@"USD"];
    }

    [Adjust trackEvent:event];
}

- (void)trackEventWithToken:(NSString *)token viewMode:(FUCollectionViewMode)viewMode
{
    ADJEvent *event = [ADJEvent eventWithEventToken:token];
    
    NSMutableDictionary *callbackParameters = [self callbackParametersWithViewMode:viewMode];
    
    [callbackParameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [event addCallbackParameter:key value:value];
    }];
    
    [Adjust trackEvent:event];
}

#pragma mark - Callback Parameters

- (NSMutableDictionary *)callbackParametersWithProduct:(FUProduct *)product
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setTrackingValue:product.name forKey:@"product_name"];
    [dictionary setTrackingValue:product.identifier forKey:@"product_sku"];
    [dictionary setTrackingValue:product.price.stringValue forKey:@"product_price"];
    [dictionary setTrackingValue:product.houzzURL.absoluteString forKey:@"product_url"];

    [dictionary setTrackingValue:product.seller.name forKey:@"seller_name"];
    [dictionary setTrackingValue:product.seller.houzzURL.absoluteString forKey:@"seller_url"];
    
    [dictionary setTrackingValue:product.properties.category forKey:@"product_category"];
    [dictionary setTrackingValue:product.properties.style forKey:@"product_style"];

    return dictionary;
}

- (NSMutableDictionary *)callbackParametersWithViewMode:(FUCollectionViewMode)viewMode
{
    NSMutableDictionary *callbackParameters = [NSMutableDictionary dictionary];
    
    NSString *modeString = viewMode == FUCollectionViewModeMatrix ? @"matrix" : @"grid";
    
    [callbackParameters setTrackingValue:modeString forKey:@"view_mode"];
    
    return callbackParameters;
}

@end
