//
//  FUNumberFormatter.m
//  furn
//
//  Created by Markus Bösch on 08/04/15.
//
//

#import "FUNumberFormatter.h"

@implementation FUNumberFormatter

+ (NSNumberFormatter *)currencyNumberFormatter
{
    static NSNumberFormatter *currencyFormatter;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currencyFormatter = [NSNumberFormatter new];
        currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        currencyFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en-US"];
    });
    
    return currencyFormatter;
}

@end
