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

@end
