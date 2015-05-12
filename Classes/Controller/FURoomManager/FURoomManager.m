//
//  FURoomManager.m
//  furn
//
//  Created by Stephan Krusche on 13/05/15.
//
//

#import "FURoomManager.h"
#import "FURoomList.h"
#import "FUAPIConstants.h"

NSString *const FURoomManagerDidFinishLoadingCategories = @"FURoomManagerDidFinishLoadingCategories";

@interface FURoomManager ()

@property (strong, nonatomic) FURoomList *roomList;

@property (strong, nonatomic) NSMutableOrderedSet *roomNameSet;

@property (strong, nonatomic) NSMutableDictionary *roomDictionary;

@property (strong, nonatomic) NSArray *roomNames;

@property (assign, nonatomic) BOOL isLoading;

@end


@implementation FURoomManager

+ (void)setup
{
    [self sharedManager];
}

+ (instancetype)sharedManager
{
    static FURoomManager *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [FURoomManager new];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.roomNameSet = [NSMutableOrderedSet orderedSet];
        self.roomDictionary = [NSMutableDictionary dictionary];

        [self loadRooms];
    }

    return self;
}

#pragma mark - Public

- (void)registerRoom:(FURoom *)room
{
    if (room.name.length > 0) {
        [self.roomNameSet addObject:room.name];
        [self.roomDictionary setObject:room forKey:room.name];
    }
}

#pragma mark - Private

- (void)loadRooms
{
    self.isLoading = YES;

    [JSONHTTPClient getJSONFromURLWithString:FUAPIRooms completion:^(id json, JSONModelError *error) {
        if (json && !error) {
            self.roomList = [[FURoomList alloc] initWithDictionary:json error:&error];
        }
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:FURoomManagerDidFinishLoadingCategories object:nil];
        }

        self.isLoading = NO;
    }];
}

- (NSArray *)roomNames
{
    if (!_roomNames) {
        _roomNames = self.roomNameSet.array;
    }
    
    return _roomNames;
}

- (NSArray *)roomNamesMatchingSearchQuery:(NSString *)searchQuery
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", searchQuery];

    return [self.roomNames filteredArrayUsingPredicate:predicate];
}

- (FURoom *)roomForName:(NSString *)roomName
{
    return [self.roomDictionary objectForKey:roomName];
}

@end
