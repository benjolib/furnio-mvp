//
//  FUCategory.h
//  furn
//
//  Created by Markus Bösch on 15/04/15.
//
//

#import "JSONModel.h"

@protocol FUCategory <NSObject>

@end

@interface FUCategory : JSONModel

@property (strong, nonatomic) NSNumber *identifier;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSNumber *level;

@property (strong, nonatomic) NSURL<Optional> *houzzURL;

@property (strong, nonatomic) NSArray<FUCategory> *children;

@property (assign, nonatomic, readonly) BOOL hasChildren;

@property (assign, nonatomic, readonly) BOOL isRootCategory;

@end
