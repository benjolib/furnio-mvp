//
//  FURoomManager.h
//  furn
//
//  Created by Stephan Krusche on 13/05/15.
//
//

#import <Foundation/Foundation.h>

extern NSString *const FURoomManagerDidFinishLoadingCategories;

@class FURoom;
@class FURoomList;

@interface FURoomManager : NSObject

@property (strong, nonatomic, readonly) FURoomList *roomList;

@property (assign, nonatomic, readonly) BOOL isLoading;

@property (strong, nonatomic, readonly) NSArray *RoomNames;

+ (void)setup;

+ (instancetype)sharedManager;

- (void)registerRoom:(FURoom *)room;

- (NSArray *)roomNamesMatchingSearchQuery:(NSString *)searchQuery;

- (FURoom *)roomForName:(NSString *)roomName;


@end
