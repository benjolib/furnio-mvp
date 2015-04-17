//
//  FUCategory.m
//  furn
//
//  Created by Markus Bösch on 15/04/15.
//
//

#import "FUCategory.h"

@implementation FUCategory

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"category.id" : @"identifier",
        @"category.name" : @"name",
        @"category.level" : @"level",
        @"category.url" : @"houzzURL"
    }];
}

#pragma mark - Getter

- (BOOL)hasChildren
{
    return self.children.count > 0;
}

- (BOOL)isRootCategory
{
    return self.level.integerValue == 1;
}

@end
