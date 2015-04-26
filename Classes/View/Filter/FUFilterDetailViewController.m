//
//  FUFilterDetailViewController.m
//  furn
//
//  Created by Stephan Krusche on 26/04/15.
//
//

#import "FUFilterDetailViewController.h"

@interface FUFilterDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (strong, nonatomic) NSArray* filterItemKeys;

@end

@implementation FUFilterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    //TODO: border around filter button
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;

    self.navItem.title = self.name;
    
    self.filterItemKeys = [[self.filterItems allKeys] sortedArrayUsingSelector: @selector(localizedCompare:)];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filterItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"FilterDetailCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    NSString *filterName = self.filterItemKeys[indexPath.row];
    cell.textLabel.text = filterName;
    if ([self.filterItems[filterName] boolValue] == YES) {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    else {
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *filterName = self.filterItemKeys[indexPath.row];
    self.filterItems[filterName] = @(![self.filterItems[filterName] boolValue]);
    [self.tableView reloadData];
}

- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)applyFilter:(id)sender {
    //TODO
}

- (IBAction)removeFilter:(id)sender {
    //TODO
}

@end
