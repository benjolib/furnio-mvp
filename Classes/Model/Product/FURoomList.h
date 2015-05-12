//
//  FURoomList.h
//  furn
//
//  Created by Stephan Krusche on 13/05/15.
//
//

#import "JSONModel.h"

#import "FURoom.h"

@interface FURoomList : JSONModel

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray<FURoom> *rooms;

@end