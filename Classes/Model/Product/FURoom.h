//
//  FURoom.h
//  furn
//
//  Created by Stephan Krusche on 13/05/15.
//
//

#import "JSONModel.h"

@protocol FURoom <NSObject>

@end

@interface FURoom : JSONModel <NSCoding>

@property (strong, nonatomic) NSString *identifier;

@property (strong, nonatomic) NSString *name;

@end
