//
//  FUProduct.m
//  furn
//
//  Created by Markus Bösch on 07/04/15.
//
//

#import "FUProduct.h"

@implementation FUProduct

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
       @"id" : @"identifier",
       @"categories" : @"categories",
       @"houzz_url" : @"houzzURL",
       @"visit_store_url" : @"storeURL",
       @"name" : @"name",
       @"price" : @"price",
       @"currency" : @"currency",
       @"description" : @"text",
       @"shipment_cost" : @"shipmentCost",
       @"shipment_term" : @"shipmentTerms",
       @"images" : @"imageURLs",
       @"seller" : @"seller",
       @"properties" : @"properties"
    }];
}

#pragma mark - Getter

- (NSURL<Ignore> *)catalogImageURL
{
    if (self.imageURLs.count > 0) {
        return [NSURL URLWithString:self.imageURLs.firstObject];
    }
    
    return nil;
}

- (NSURL<Ignore> *)productURL
{
    if (self.storeURL.absoluteString.length > 0) {
        return self.storeURL;
    } else {
        return self.houzzURL;
    }
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];

    if (self) {
        for (NSString *keyPath in [FUProduct keypathsForCoding]) {
            [self setValue:[coder decodeObjectForKey:keyPath] forKeyPath:keyPath];
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    for (NSString *keyPath in [FUProduct keypathsForCoding]) {
        [coder encodeObject:[self valueForKeyPath:keyPath] forKey:keyPath];
    }
}

+ (NSArray *)keypathsForCoding
{
    static NSArray *keyPaths;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyPaths = @[ @"identifier", @"categories", @"houzzURL", @"name", @"price", @"currency", @"text", @"shipmentCost", @"shipmentTerms", @"imageURLs", @"seller", @"properties" ];
    });

    return keyPaths;
}

@end
