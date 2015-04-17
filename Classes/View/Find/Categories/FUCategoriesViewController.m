//
//  FUCategoriesViewController.m
//  furn
//
//  Created by Markus Bösch on 13/04/15.
//
//

#import "FUCategoriesViewController.h"

#import "FUCategoryTableViewCell.h"
#import "FUCatalogViewController.h"
#import "FUCategory.h"
#import "FUCategoryManager.h"
#import "FUCategoryList.h"
#import "FULoadingViewManager.h"
#import "FUProductManager.h"

@interface FUCategoriesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *categories;

@property (strong, nonatomic) FUCategory *selectedCategory;

@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;

@end

@implementation FUCategoriesViewController


#pragma mark - Initialization

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCategories:(NSArray *)categories
{
    return [self initWithCategories:categories selectedCategory:nil];
}

- (instancetype)initWithCategories:(NSArray *)categories selectedCategory:(FUCategory *)category
{
    self = [super init];
    
    if (self) {
        self.categories = categories;
        self.selectedCategory = category;
    }
    
    return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"CATEGORIES";
    
    [self.categoryTableView registerNib:[FUCategoryTableViewCell nib] forCellReuseIdentifier:FUCategoryTableViewCellReuseIdentifier];
    
    [self setupNotifications];
}

#pragma mark - FUViewController

- (void)configureNavigationBar
{
    self.navigationBar.leftButton = [self.navigationBar newBackButton];
}

- (void)configureLoadingView
{
    [FULoadingViewManager sharedManger].text = @"LOADING CATEGORIES";
    [FULoadingViewManager sharedManger].allowLoadingView = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0 : return self.selectedCategory ? 1 : 0;
        case 1 : return self.categories.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 0 ? 40 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FUCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FUCategoryTableViewCellReuseIdentifier];
    
    if (indexPath.section == 0 && self.selectedCategory) {
        cell.isAllProductsCell = YES;
        cell.category = self.selectedCategory;
    } else {
        cell.isAllProductsCell = NO;
        cell.category = [self categoryAtIndexPath:indexPath];
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FUCategory *selectedCategory = [self categoryAtIndexPath:indexPath];

    if (selectedCategory.hasChildren) {
        if (indexPath.section == 0) {
            [FUProductManager sharedManager].category = selectedCategory;
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            FUCategoriesViewController *categoriesViewController = [[FUCategoriesViewController alloc] initWithCategories:selectedCategory.children selectedCategory:selectedCategory];

            [self.navigationController pushViewController:categoriesViewController animated:YES];
        }
    } else {
        [FUProductManager sharedManager].category = selectedCategory;

        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Notifications

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:FUCategoryManagerDidFinishLoadingCategories object:nil];
}

- (void)reload
{
    self.categories = [FUCategoryManager sharedManager].categoryList.categories;
    
    [self.categoryTableView reloadData];
}

#pragma mark - Private

- (BOOL)isRootLevel
{
    return self.selectedCategory != nil;
}

- (FUCategory *)categoryAtIndexPath:(NSIndexPath *)indexPath
{
    FUCategory *category;

    if (indexPath.row < self.categories.count) {
        category = [self.categories objectAtIndex:indexPath.row];
    }
    
    return category;
}

@end
