//
//  FUProductAction.h
//  furn
//
//  Created by Stephan Krusche on 25/04/15.
//
//

#import <Foundation/Foundation.h>

@class FUProduct;

typedef enum : NSUInteger {
    FUActionTypeLike,
    FUActionTypeDiscard,
} FUActionType;

@interface FUProductAction : NSObject

@property(strong, nonatomic) FUProduct *product;
@property(assign, nonatomic) FUActionType actionType;

- (instancetype)initWithProduct:(FUProduct *)product action:(FUActionType) actionType;

- (void) undo;
- (void) execute;

@end
