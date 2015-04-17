//
//  FUCategoryList.m
//  furn
//
//  Created by Markus Bösch on 15/04/15.
//
//

#import "FUCategoryList.h"

@implementation FUCategoryList

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"data" : @"categories" } ];
}

@end
