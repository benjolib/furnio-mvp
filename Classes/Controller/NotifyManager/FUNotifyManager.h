//
//  FUNotifyManager.h
//  furn
//
//  Created by Markus Bösch on 09/04/15.
//
//

#import <Foundation/Foundation.h>

@interface FUNotifyManager : NSObject

+ (void)setup;

+ (instancetype)sharedManager;

- (void)showMessageWithText:(NSString *)text;
- (void)showMessageWithText:(NSString *)text backgroundColor:(UIColor *)backgroundColor;

- (void)hideMessage;

@end
