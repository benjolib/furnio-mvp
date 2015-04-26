//
//  NSMutableDictionary+Tracking.m
//  furn
//
//  Created by Markus Bösch on 26/04/15.
//
//

#import "NSMutableDictionary+Tracking.h"

@implementation NSMutableDictionary (Tracking)

- (void)setTrackingValue:(NSString *)value forKey:(NSString *)key
{
    if ([self isValidTrackingString:key] && [self isValidTrackingString:value]) {
        [self setObject:value forKey:key];
    } else {
        NSLog(@"Tracking: Invalid key / value combination - <%@ - %@>", key, value);
    }
}

- (BOOL)isValidTrackingString:(NSString *)string
{
    return string && [string isKindOfClass:[NSString class]] && string.length > 0;
}

- (void)setValidObject:(id)object forKey:(id<NSCopying>)key
{
    if (object && key) {
        [self setObject:object forKey:key];
    }
}

@end
