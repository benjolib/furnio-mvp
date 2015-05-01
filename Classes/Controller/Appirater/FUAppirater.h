//
//  FUAppirater.h
//  furn
//
//  Created by Markus Bösch on 01/05/15.
//

#import "Appirater.h"

@class FUAlertView;


@interface FUAppirater : Appirater

@property (nonatomic, strong) FUAlertView *alertView;

+ (instancetype)sharedInstance;

@end
