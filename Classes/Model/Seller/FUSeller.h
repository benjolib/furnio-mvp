//
//  FUSeller.h
//  furn
//
//  Created by Markus Bösch on 08/04/15.
//
//

#import "JSONModel.h"

@interface FUSeller : JSONModel

@property (strong, nonatomic) NSString *identifier;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSURL *houzzURL;

@end
