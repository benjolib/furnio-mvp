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

#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>
#import <GoogleAnalytics-iOS-SDK/GAIEcommerceProduct.h>
#import <GoogleAnalytics-iOS-SDK/GAIEcommerceProductAction.h>
#import <GoogleAnalytics-iOS-SDK/GAIEcommerceFields.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

#import <Adjust.h>

#define DEPLOY_CALLBACK_PARAMETERS 0

@interface FUTrackingManager ()

@property (strong, nonatomic) id<GAITracker> tracker;

@end

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

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.tracker = [[GAI sharedInstance] defaultTracker];
    }

    return self;
}

#pragma mark - Tracking

- (void)trackRateApp
{
    [self trackEventWithToken:@"g90yjx"];
}

- (void)trackPDPBuyProduct:(FUProduct *)product
{
    [self trackEventWithToken:@"q5wegn" product:product revenue:product.price];
    
    [self trackProduct:product actionName:kGAIPACheckout listName:@"Checkout" screenName:@"PDP Browser"];
}

- (void)trackPDPLikeProduct:(FUProduct *)product
{
    [self trackEventWithToken:@"4lb05e" product:product];
    
    [self trackProduct:product actionName:kGAIPAAdd listName:@"Wishlist Add" screenName:@"Wishlist"];
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
    
    [self trackProduct:product actionName:kGAIPARemove listName:@"Wishlist Remove" screenName:@"Wishlist"];
}

- (void)trackWishlistShareProduct:(FUProduct *)product
{
    [self trackEventWithToken:@"f9ygjy" product:product];
    
    [self trackProduct:product actionName:kGAIPAClick listName:@"Wishlist Share" screenName:@"Wishlist"];
}

- (void)trackCatalogViewMode:(FUCollectionViewMode)viewMode
{
    [self trackEventWithToken:@"xlr8n5" viewMode:viewMode];
}

- (void)trackOnboardingResults:(NSArray *)results forScreenIndex:(NSUInteger)index
{
    NSString *value;
    
    if (results.count > 0) {
        results = [results sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES] ]];
        value = [results componentsJoinedByString:@", "];
    } else {
        value = @"<no selection>";
    }

    [self.tracker set:[GAIFields customDimensionForIndex:index] value:value];
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
    
#if DEPLOY_CALLBACK_PARAMETERS
    if (product) {
        NSMutableDictionary *callbackParameters = [self callbackParametersWithProduct:product];
        
        [callbackParameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            [event addCallbackParameter:key value:value];
        }];
    }
#endif

    if (revenue && revenue.doubleValue > 0) {
        [event setRevenue:revenue.doubleValue currency:@"USD"];
    }

    [Adjust trackEvent:event];
}

- (void)trackEventWithToken:(NSString *)token viewMode:(FUCollectionViewMode)viewMode
{
    ADJEvent *event = [ADJEvent eventWithEventToken:token];
    
#if DEPLOY_CALLBACK_PARAMETERS
    NSMutableDictionary *callbackParameters = [self callbackParametersWithViewMode:viewMode];
    
    [callbackParameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [event addCallbackParameter:key value:value];
    }];
#endif

    [Adjust trackEvent:event];
}

#pragma mark - Callback Parameters (not in use)

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

- (void)trackProduct:(FUProduct *)product actionName:(NSString *)actionName listName:(NSString *)listName screenName:(NSString *)screenName
{
    GAIEcommerceProduct *commerce = [GAIEcommerceProduct new];
    
    [commerce setId:product.identifier];
    [commerce setName:product.name];
    [commerce setCategory:product.properties.category];
    [commerce setBrand:product.properties.manufacturer];
    [commerce setVariant:product.houzzURL.absoluteString];
    [commerce setPrice:product.price];
    
    GAIEcommerceProductAction *action = [GAIEcommerceProductAction new];
    [action setAction:actionName];
    [action setProductActionList:listName];
    
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createScreenView];
    [builder setProductAction:action];
    [builder addProduct:commerce];
    
    [self.tracker set:kGAIScreenName value:screenName];
    [self.tracker send:[builder build]];
}

@end
