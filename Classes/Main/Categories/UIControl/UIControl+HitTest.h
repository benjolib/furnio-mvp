//
// Copyright (c) 2014 
// All rights reserved.
//

// source: http://www.pressingquestion.com/138576/Uibutton-Making-The-Hit-Area-Larger-Than-The-Default-Hit-Area

#import <UIKit/UIKit.h>

@interface UIControl (HitTest)

@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

@end
