//
//  FUProperties.m
//  furn
//
//  Created by Markus Bösch on 09/04/15.
//
//

#import "FUProperties.h"

@implementation FUProperties

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"Category" : @"category",
        @"Color" : @"color",
        @"Designer" : @"designer",
        @"Manufactured By" : @"manufacturer",
        @"Materials" : @"materials",
        @"Sold By" : @"soldBy",
        @"Depth" : @"depth",
        @"Height" : @"height",
        @"Width" : @"Width"
    }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
