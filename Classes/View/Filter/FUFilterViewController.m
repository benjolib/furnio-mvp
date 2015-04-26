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

@interface FUFilterViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) NSMutableDictionary *categoryFilterItems;

@end

@implementation FUFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FILTER";
    self.tableView.backgroundColor = [UIColor clearColor];
    self.categoryFilterItems = [self dictionaryForCategories];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"FilterCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"Category";
//            NSArray *categoryFilters = [[NSUserDefaults standardUserDefaults] arrayForKey:@"CategoryFilter"];
//            if (!categoryFilters || [categoryFilters count] == 0) {
//                cell.detailTextLabel.text = @"";
//            }
            
            NSMutableString *detailString = [NSMutableString string];
            
            for(NSString *categoryFilterName in self.categoryFilterItems) {
                if([self.categoryFilterItems[categoryFilterName] boolValue]) {
                    [detailString appendFormat:@"%@, ", categoryFilterName];
                }
            }
            
            cell.detailTextLabel.text = detailString;
            
            if(![detailString isEqualToString:@""]) {
                cell.textLabel.textColor = [UIColor blackColor];
            }
            else {
                cell.textLabel.textColor = [UIColor lightGrayColor];
            }
            
            break;
        }
        case 1:
        {
            cell.textLabel.text = @"Style";
            NSArray *styleFilters = [[NSUserDefaults standardUserDefaults] arrayForKey:@"StyleFilter"];
            if (!styleFilters || [styleFilters count] == 0) {
                cell.detailTextLabel.text = @"";
            }

//            cell.detailTextLabel.text = @"Style";
            break;
        }
        case 2:
        {
            cell.textLabel.text = @"Room";
            NSArray *roomFilters = [[NSUserDefaults standardUserDefaults] arrayForKey:@"roomFilter"];
            if (!roomFilters || [roomFilters count] == 0) {
                cell.detailTextLabel.text = @"";
            }
            
//            cell.detailTextLabel.text = @"Room";
            break;
        }
        case 3:
        {
            cell.textLabel.text = @"Price";
            NSArray *priceFilters = [[NSUserDefaults standardUserDefaults] arrayForKey:@"priceFilter"];
            if (!priceFilters || [priceFilters count] == 0) {
                cell.detailTextLabel.text = @"";
            }

//            cell.detailTextLabel.text = @"Price";
            break;
        }
        case 4:
        {
            cell.textLabel.text = @"Merchant";
            NSArray *merchantFilters = [[NSUserDefaults standardUserDefaults] arrayForKey:@"merchantFilter"];
            if (!merchantFilters || [merchantFilters count] == 0) {
                cell.detailTextLabel.text = @"";
            }

//            cell.detailTextLabel.text = @"Merchant";
            break;
        }
        default:
            break;
    }
    
    return cell;
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
    NSLog(@"Apply Filter");
}

- (IBAction)removeAllFilter:(id)sender {
    NSLog(@"Remove Filter");
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@", segue.identifier);
    if ([segue.identifier isEqualToString:@"FilterDetail"]) {

        //pass translucent back image
        FUFilterDetailViewController *filterDetailViewController = segue.destinationViewController;
        filterDetailViewController.view.backgroundColor = self.view.backgroundColor;
        
        
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        if (selectedIndexPath.row == 0) {
            filterDetailViewController.name = @"CATEGORY";
            filterDetailViewController.filterItems = self.categoryFilterItems;
        }
        
        //TODO: pass some information

    }
    else if ([segue.identifier isEqualToString:@"FilterPrice"]) {
        //TODO
    }
}

- (NSMutableDictionary *) dictionaryForCategories {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for(FUCategory *category in [FUCategoryManager sharedManager].categoryList.categories) {
        NSLog(@"category: %@", category.name);
        dictionary[category.name] = @NO;
        //TODO: get this information from e.g. user defaults
    }
    return dictionary;
}


@end
