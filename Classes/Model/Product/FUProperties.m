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

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    
    if (self) {
        for (NSString *keyPath in [FUProperties keypathsForCoding]) {
            [self setValue:[coder decodeObjectForKey:keyPath] forKeyPath:keyPath];
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    for (NSString *keyPath in [FUProperties keypathsForCoding]) {
        [coder encodeObject:[self valueForKeyPath:keyPath] forKey:keyPath];
    }
}

+ (NSArray *)keypathsForCoding
{
    static NSArray *keyPaths;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyPaths = @[ @"category", @"color", @"designer", @"manufacturer", @"materials", @"soldBy", @"depth", @"height", @"width" ];
    });

    return keyPaths;
}


@end
