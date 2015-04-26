//
//  FUFilterViewController.m
//  furn
//
//  Created by Stephan Krusche on 25/04/15.
//
//

#import "FUFilterViewController.h"
#import "FUCategoryManager.h"
#import "FUCategoryList.h"
#import "FUCategory.h"
#import "FUFilterDetailViewController.h"
#import "FUFilterPriceViewController.h"
#import "FUFilterManager.h"

@interface FUFilterViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) NSMutableDictionary *allFilterItems;

@end

@implementation FUFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FILTER";
    self.tableView.backgroundColor = [UIColor clearColor];
    [self loadFilters];
    //TODO: border around filter button
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void) loadFilters {
    self.allFilterItems = [[FUFilterManager sharedManager] loadAllFilterItems];
    //make the inner dictionaries mutable
    for (NSString *key in [self.allFilterItems allKeys]) {
        self.allFilterItems[key] = [self.allFilterItems[key] mutableCopy];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell;
    switch (indexPath.row) {
        case 3: //Price
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"FilterPriceCell" forIndexPath:indexPath];
            break;
        default:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"FilterCell" forIndexPath:indexPath];
            break;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    NSString *detailString;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"Category";
            detailString = [self detailStringForFilterItems:FUFilterCategoryKey];
            break;
        }
        case 1:
        {
            cell.textLabel.text = @"Style";
            detailString = [self detailStringForFilterItems:FUFilterStyleKey];
            break;
        }
        case 2:
        {
            cell.textLabel.text = @"Room";
            detailString = [self detailStringForFilterItems:FUFilterRoomKey];
            break;
        }
        case 3:
        {
            cell.textLabel.text = @"Price";
            detailString = [self detailStringForPriceItems];
            break;
        }
        case 4:
        {
            cell.textLabel.text = @"Merchant";
            detailString = [self detailStringForFilterItems:FUFilterMerchantKey];
            break;
        }
        default:
            break;
    }
    
    cell.detailTextLabel.text = detailString;
    
    if(![detailString isEqualToString:@" "]) {
        cell.textLabel.textColor = [UIColor blackColor];
        
        UIImage *checkedImage = [UIImage imageNamed:@"close"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 25, 25);
        button.tag = indexPath.row;
        [button addTarget:self action:@selector(removeSingleFilterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:checkedImage forState:UIControlStateNormal];
        cell.accessoryView = button;
    }
    else {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        UIImage *checkedImage = [UIImage imageNamed:@"forward"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 13, 25);
        [button setImage:checkedImage forState:UIControlStateNormal];
        cell.accessoryView = button;
    }
    
    return cell;
}

- (void)removeSingleFilterButtonTapped:(UIButton *)button {
    switch (button.tag) {
        case 0:
            //TODO : reset filter preferences of Category
            break;
        case 1:
            //TODO : reset filter preferences of Style
            break;
        case 2:
            //TODO : reset filter preferences of Room
            break;
        case 3:
            //TODO : reset filter preferences of Price
            break;
        case 4:
            //TODO : reset filter preferences of Merchant
            break;
            
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:     //Category
        {
            break;
        }
        case 1:     //Style
        {
            break;
        }
        case 2:     //Room
        {
            break;
        }
        case 3:     //Price
        {
            break;
        }
        case 4:     //Merchant
        {
            break;
        }
        default:
            break;
    }
}


- (IBAction)applyFilter:(id)sender {
    [[FUFilterManager sharedManager] saveAllFilterItems:self.allFilterItems];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)removeAllFilter:(id)sender {
    [[FUFilterManager sharedManager] resetAllFilters];
    [self loadFilters];
    [self.tableView reloadData];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@", segue.identifier);
    if ([segue.identifier isEqualToString:@"FilterDetail"]) {

        FUFilterDetailViewController *filterDetailViewController = segue.destinationViewController;
        filterDetailViewController.view.backgroundColor = self.view.backgroundColor;
        
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        switch (selectedIndexPath.row) {
            case 0:
                filterDetailViewController.name = @"CATEGORY";
                filterDetailViewController.filterItems = self.allFilterItems[FUFilterCategoryKey];
                break;
            case 1:
                filterDetailViewController.name = @"STYLE";
                filterDetailViewController.filterItems = self.allFilterItems[FUFilterStyleKey];
                break;
            case 2:
                filterDetailViewController.name = @"ROOM";
                filterDetailViewController.filterItems = self.allFilterItems[FUFilterRoomKey];
                break;
            case 4:
                filterDetailViewController.name = @"MERCHANT";
                filterDetailViewController.filterItems = self.allFilterItems[FUFilterMerchantKey];
                break;
                
            default:
                break;
        }
    }
    else if ([segue.identifier isEqualToString:@"FilterPrice"]) {

        FUFilterPriceViewController *filterPriceViewController = segue.destinationViewController;
        filterPriceViewController.view.backgroundColor = self.view.backgroundColor;

        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        switch (selectedIndexPath.row) {
            case 3:
                filterPriceViewController.name = @"PRICE";
                filterPriceViewController.filterItems = self.allFilterItems[FUFilterPriceKey];
                break;
            default:
                break;
        }
    }
}

- (NSString *)detailStringForFilterItems:(NSString *) key {
    NSMutableString *detailString = [NSMutableString string];
    
    NSDictionary *filterItems = self.allFilterItems[key];
    for(NSString *filterName in filterItems) {
        if([filterItems[filterName] boolValue]) {
            [detailString appendFormat:@"%@, ", filterName];
        }
    }
    
    if(detailString.length == 0) {
        //workaround for a problem in iOS that for some reason the subtitle is not shown otherwise
        return @" ";
    }
    
    return [detailString substringToIndex:detailString.length - 2];
}

- (NSString *)detailStringForPriceItems {
    NSMutableString *detailString = [NSMutableString string];
    
    NSDictionary *filterItems = self.allFilterItems[FUFilterPriceKey];
    
    for(NSString *filterName in filterItems) {
        NSInteger value = [filterItems[filterName] integerValue];
        [detailString appendFormat:@"%@:%li €, ", filterName, (long)value];
    }
    
    return [detailString substringToIndex:detailString.length - 2];
}

@end
