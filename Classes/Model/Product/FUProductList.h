//
//  FUProductList.h
//  furn
//
//  Created by Markus Bösch on 08/04/15.
//
//

#import "JSONModel.h"

#import "FUProduct.h"

@interface FUProductList : JSONModel

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray<FUProduct> *products;

@property (nonatomic, strong) NSNumber *totalCount;

@end
