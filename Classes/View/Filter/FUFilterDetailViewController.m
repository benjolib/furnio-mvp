//
//  FUFilterDetailViewController.m
//  furn
//
//  Created by Stephan Krusche on 26/04/15.
//
//

#import "FUFilterDetailViewController.h"
#import "FUFontConstants.h"
#import "FUColorConstants.h"

@interface FUFilterDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIButton *applyFilterButton;

@property (strong, nonatomic) NSArray* filterItemKeys;
@property (nonatomic, strong) NSMutableDictionary *currentFilterItems;

@end

@implementation FUFilterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.applyFilterButton.layer.borderWidth = 1.5f;
    self.applyFilterButton.layer.borderColor = [[UIColor colorWithRed:244.0/255.0 green:170.0/255.0 blue:56.0/255.0 alpha:1.0] CGColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
    
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName : FUFontNavigationTitle, NSForegroundColorAttributeName : FUColorDarkGray}];
    self.navItem.title = self.name;
    
    self.currentFilterItems = [self.previousFilterItems mutableCopy];
    self.filterItemKeys = [[self.currentFilterItems allKeys] sortedArrayUsingSelector: @selector(localizedCompare:)];
    
    if((self.view.frame.size.height - 211) / [self.filterItemKeys count] < 44) {
        //make tableView scrollable
        self.tableView.scrollEnabled = YES;
        self.tableView.bounces = YES;
    }
    else {
        self.tableView.scrollEnabled = NO;
        self.tableView.bounces = NO;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat dynamicHeight = (self.view.frame.size.height - 211) / [self.filterItemKeys count];
    
    if(dynamicHeight >= 44) {
        return dynamicHeight;
    }
    else {
        return 44; //minHeight
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.currentFilterItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"FilterDetailCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    NSString *filterName = self.filterItemKeys[indexPath.row];
    cell.textLabel.text = filterName;
    if ([self.currentFilterItems[filterName] boolValue] == YES) {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    else {
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    
    if([self.currentFilterItems[filterName] boolValue]) {
        UIImage *checkedImage = [UIImage imageNamed:@"check-arrow"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:checkedImage];
        cell.accessoryView = imageView;
    }
    else {
        cell.accessoryView = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *filterName = self.filterItemKeys[indexPath.row];
    self.currentFilterItems[filterName] = @(![self.currentFilterItems[filterName] boolValue]);
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)applyFilter:(id)sender {
    for(NSString *filterItemKey in self.filterItemKeys) {
        // save all current filters to the previous list owned by FUFilterViewController
        self.previousFilterItems[filterItemKey] = self.currentFilterItems[filterItemKey];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)removeFilter:(id)sender {
    for(NSString *filterItemKey in self.filterItemKeys) {
        self.currentFilterItems[filterItemKey] = @NO;
    }
    [self.tableView reloadData];
}

@end
