//
//  FUNotifyManager.h
//  furn
//
//  Created by Markus Bösch on 09/04/15.
//
//

#import <Foundation/Foundation.h>

@class UIColor;

@interface FUNotifyManager : NSObject

+ (void)setup;

+ (instancetype)sharedManager;

- (void)showMessageWithText:(NSString *)text;
- (void)showMessageWithText:(NSString *)text backgroundColor:(UIColor *)backgroundColor isTranslucent:(BOOL)isTranslucent;
- (void)showMessageWithText:(NSString *)text backgroundColor:(UIColor *)backgroundColor hideAfterTimeInterval:(NSTimeInterval)timeInterval isTranslucent:(BOOL)isTranslucent;

- (void)hideMessage;

@end
