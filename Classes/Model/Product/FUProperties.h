//
//  FUProperties.h
//  furn
//
//  Created by Markus Bösch on 09/04/15.
//
//

#import "JSONModel.h"

@interface FUProperties : JSONModel

@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *designer;
@property (strong, nonatomic) NSString *manufacturer;
@property (strong, nonatomic) NSString *materials;
@property (strong, nonatomic) NSString *soldBy;
@property (strong, nonatomic) NSString *depth;
@property (strong, nonatomic) NSString *height;
@property (strong, nonatomic) NSString *width;

@end
