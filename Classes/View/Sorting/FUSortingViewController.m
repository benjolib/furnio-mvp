//
//  FUSortingViewController.m
//  furn
//
//  Created by Stephan Krusche on 03/05/15.
//
//

#import "FUSortingViewController.h"
#import "FUFilterManager.h"
#import "FUProductManager.h"
#import "FUFontConstants.h"
#import "FUColorConstants.h"

#define SORTING_CELL @"SortingCell"

@interface FUSortingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *sortingStrings;
@property (nonatomic, strong) NSString *chosenSorting;

@end

@implementation FUSortingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FILTER";
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.sortingStrings = @[FUSortingEnableSorting, FUSortingPriceHighToLow, FUSortingPriceLowToHigh, FUSortingPopularToday, FUSortingLatestActivity, FUSortingAllTimePopular, FUSortingNewlyFeatures];
    self.chosenSorting = [[FUFilterManager sharedManager] loadSortingString];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SORTING_CELL];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sortingStrings count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SORTING_CELL forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.sortingStrings[indexPath.row];
    cell.textLabel.font = FUFontAvenirLight(17);
    
    
    if([self.sortingStrings[indexPath.row] isEqualToString:self.chosenSorting]) {
        UIImage *checkedImage = [UIImage imageNamed:@"check-arrow-yellow"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:checkedImage];
        cell.accessoryView = imageView;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    else {
        cell.accessoryView = nil;
        cell.textLabel.textColor = FUColorLightGray;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *chosenString = self.sortingStrings[indexPath.row];
    self.chosenSorting = chosenString;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [[FUFilterManager sharedManager] saveSortingString:chosenString];
    [[FUProductManager sharedManager] sortProducts];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
