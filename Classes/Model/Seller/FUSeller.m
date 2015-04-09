//
//  FUSeller.m
//  furn
//
//  Created by Markus Bösch on 08/04/15.
//
//

#import "FUSeller.h"

@implementation FUSeller

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:
        @{ @"id" : @"identifier",
           @"name" : @"name",
           @"houzz_url" : @"houzzURL"
        }
    ];
}

@end
