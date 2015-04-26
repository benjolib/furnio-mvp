//
//  NSMutableDictionary+Tracking.h
//  furn
//
//  Created by Markus Bösch on 26/04/15.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Tracking)

- (void)setTrackingValue:(NSString *)value forKey:(NSString *)key;

- (BOOL)isValidTrackingString:(NSString *)string;

- (void)setValidObject:(id)object forKey:(id<NSCopying>)key;

@end
