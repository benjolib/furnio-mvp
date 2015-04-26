//
//  FUCategoryManager.m
//  furn
//
//  Created by Markus Bösch on 15/04/15.
//
//

#import "FUCategoryManager.h"

#import "FUCategoryManager.h"
#import "FUCategoryList.h"
#import "FUAPIConstants.h"

NSString *const FUCategoryManagerDidFinishLoadingCategories = @"FUCategoryManagerDidFinishLoadingCategories";

@interface FUCategoryManager ()

@property (strong, nonatomic) FUCategoryList *categoryList;

@property (strong, nonatomic) NSMutableOrderedSet *categoryNameSet;

@property (strong, nonatomic) NSMutableDictionary *categoryDictionary;

@property (strong, nonatomic) NSArray *categoryNames;

@property (assign, nonatomic) BOOL isLoading;

@end


@implementation FUCategoryManager

+ (void)setup
{
    [self sharedManager];
}

+ (instancetype)sharedManager
{
    static FUCategoryManager *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [FUCategoryManager new];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.categoryNameSet = [NSMutableOrderedSet orderedSet];
        self.categoryDictionary = [NSMutableDictionary dictionary];

        [self loadCategories];
    }

    return self;
}

#pragma mark - Public

- (void)registerCategory:(FUCategory *)category
{
    if (category.name.length > 0) {
        [self.categoryNameSet addObject:category.name];
        [self.categoryDictionary setObject:category forKey:category.name];
    }
}

#pragma mark - Private

- (void)loadCategories
{
    self.isLoading = YES;

    [JSONHTTPClient getJSONFromURLWithString:FUAPICategories completion:^(id json, JSONModelError *error) {
        if (json && !error) {
            self.categoryList = [[FUCategoryList alloc] initWithDictionary:json error:&error];
        }
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:FUCategoryManagerDidFinishLoadingCategories object:nil];
        }

        self.isLoading = NO;
    }];
}

- (NSArray *)categoryNames
{
    if (!_categoryNames) {
        _categoryNames = self.categoryNameSet.array;
    }
    
    return _categoryNames;
}

- (NSArray *)categoryNamesMatchingSearchQuery:(NSString *)searchQuery
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", searchQuery];

    return [self.categoryNames filteredArrayUsingPredicate:predicate];
}

- (FUCategory *)categoryForName:(NSString *)categoryName
{
    return [self.categoryDictionary objectForKey:categoryName];
}

@end
