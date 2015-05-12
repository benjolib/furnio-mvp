//
//  FURoom.m
//  furn
//
//  Created by Stephan Krusche on 13/05/15.
//
//

#import "FURoom.h"

@implementation FURoom

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"identifier",
                                                       @"name" : @"name",
                                                       }];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    
    if (self) {
        for (NSString *keyPath in [FURoom keypathsForCoding]) {
            [self setValue:[coder decodeObjectForKey:keyPath] forKeyPath:keyPath];
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    for (NSString *keyPath in [FURoom keypathsForCoding]) {
        [coder encodeObject:[self valueForKeyPath:keyPath] forKey:keyPath];
    }
}

+ (NSArray *)keypathsForCoding
{
    static NSArray *keyPaths;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyPaths = @[ @"identifier", @"name"];
    });
    
    return keyPaths;
}

@end
