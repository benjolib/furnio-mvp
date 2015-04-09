//
//  FUProductList.m
//  furn
//
//  Created by Markus Bösch on 08/04/15.
//
//

#import "FUProductList.h"

@implementation FUProductList

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:
        @{ @"success" : @"success",
           @"data" : @"products",
           @"foundRows" : @"totalCount"
        }
    ];
}

@end
