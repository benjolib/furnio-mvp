//
//  FUProduct.h
//  furn
//
//  Created by Markus Bösch on 07/04/15.
//
//

#import "JSONModel.h"

#import "FUSeller.h"
#import "FUProperties.h"

@protocol FUProduct <NSObject>

@end

@interface FUProduct : JSONModel <NSCoding>

@property (strong, nonatomic) NSString *identifier;

@property (strong, nonatomic) NSArray *categories;

@property (strong, nonatomic) NSURL *houzzURL;
@property (strong, nonatomic) NSURL<Optional> *storeURL;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSNumber *price;

@property (strong, nonatomic) NSString *currency;

@property (strong, nonatomic) NSString *text;

@property (strong, nonatomic) NSString<Optional> *shipmentCost;
@property (strong, nonatomic) NSString<Optional> *shipmentTerms;

@property (strong, nonatomic) NSArray *imageURLs;

@property (strong, nonatomic) FUSeller<Optional> *seller;

@property (strong, nonatomic) FUProperties *properties;

@property (strong, nonatomic, readonly) NSURL<Ignore> *catalogImageURL;
@property (strong, nonatomic, readonly) NSURL<Ignore> *productURL;

@end
