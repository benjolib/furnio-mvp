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

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    
    if (self) {
        for (NSString *keyPath in [FUSeller keypathsForCoding]) {
            [self setValue:[coder decodeObjectForKey:keyPath] forKeyPath:keyPath];
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    for (NSString *keyPath in [FUSeller keypathsForCoding]) {
        [coder encodeObject:[self valueForKeyPath:keyPath] forKey:keyPath];
    }
}

+ (NSArray *)keypathsForCoding
{
    static NSArray *keyPaths;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyPaths = @[ @"identifier", @"name", @"houzzURL" ];
    });
    
    return keyPaths;
}

@end
