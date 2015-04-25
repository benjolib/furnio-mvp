//
//  FUProductAction.m
//  furn
//
//  Created by Stephan Krusche on 25/04/15.
//
//

#import "FUProductAction.h"
#import "FUWishlistManager.h"
#import "FUProductManager.h"

@implementation FUProductAction

- (instancetype)initWithProduct:(FUProduct *)product action:(FUActionType) actionType
{
    self = [super init];
    if (self) {
        self.product = product;
        self.actionType = actionType;
    }
    return self;
}


- (void) undo {
    if (self.actionType == FUActionTypeLike) {
        //undo like
        [[FUWishlistManager sharedManager] removeProduct:self.product];
    }
    else {
        //undo discard
        [[FUProductManager sharedManager] addProduct:self.product];
    }
}

- (void) execute {
    if (self.actionType == FUActionTypeLike) {
        //execute like
        
        [[FUWishlistManager sharedManager] addProduct:self.product];
    }
    else {
        //execute discard
        [[FUProductManager sharedManager] removeProduct:self.product];
    }
}

@end
