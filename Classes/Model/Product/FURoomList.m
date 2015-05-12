//
//  FURoomList.m
//  furn
//
//  Created by Stephan Krusche on 13/05/15.
//
//

#import "FURoomList.h"

@implementation FURoomList

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:
            @{ @"success" : @"success",
               @"data" : @"rooms",
               }
            ];
}

@end
