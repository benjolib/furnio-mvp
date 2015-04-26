//
//  FUSearchViewController.m
//  furn
//
//  Created by Markus Bösch on 19/04/15.
//
//

#import "FUSearchViewController.h"

#import "FUSearchTextField.h"
#import "FUCategoryManager.h"
#import "FUProductManager.h"
#import "FUColorConstants.h"
#import "FUFontConstants.h"
#import "FUCategoryList.h"
#import "FUCategoryTableViewCell.h"
#import "FUCategoriesViewController.h"

static CGFloat const FUSearchViewControllerCategoriesDefaultTop = 88;


@interface FUSearchViewController () <MLPAutoCompleteTextFieldDataSource, MLPAutoCompleteTextFieldDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet FUSearchTextField *searchTextField;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (weak, nonatomic) IBOutlet UITableView *categoriesTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoriesTableViewTopConstraint;

@property (strong, nonatomic, readonly) NSArray *categories;

@end

@implementation FUSearchViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.categoriesTableView registerNib:[FUCategoryTableViewCell nib] forCellReuseIdentifier:FUCategoryTableViewCellReuseIdentifier];
    
    [self setupAutoCompleteTextField];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.view bringSubviewToFront:self.searchTextField];
}

#pragma mark - Actions

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    self.categoriesTableViewTopConstraint.constant = FUSearchViewControllerCategoriesDefaultTop;
    
    [UIView animateWithDuration:0.35f animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Getter

- (NSArray *)categories
{
    return [FUCategoryManager sharedManager].categoryList.categories;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (text.length > 0) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.searchButton.hidden = YES;
    } else {
        textField.clearButtonMode = UITextFieldViewModeNever;
        self.searchButton.hidden = NO;
    }

    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.searchButton.hidden = NO;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *searchQuery = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (searchQuery.length == 0) {
        return YES;
    }

    [FUProductManager sharedManager].searchQuery = searchQuery;
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    
    return YES;
}

#pragma mark - MLPAutoCompleteTextFieldDataSource

- (NSArray *)autoCompleteTextField:(MLPAutoCompleteTextField *)textField possibleCompletionsForString:(NSString *)string
{
    return [[FUCategoryManager sharedManager] categoryNames];
}

#pragma mark -  MLPAutoCompleteTextFieldDelegate

- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField shouldConfigureCell:(UITableViewCell *)cell withAutoCompleteString:(NSString *)autocompleteString withAttributedString:(NSAttributedString *)boldedString forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject forRowAtIndexPath:(NSIndexPath *)indexPath
{
     [self.view bringSubviewToFront:self.searchButton];

    return YES;
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField didSelectAutoCompleteString:(NSString *)selectedString withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject forRowAtIndexPath:(NSIndexPath *)indexPath
{
    FUCategory *category = [[FUCategoryManager sharedManager] categoryForName:selectedString];
    
    [FUProductManager sharedManager].category = category;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FUCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FUCategoryTableViewCellReuseIdentifier];
    
    cell.isAllProductsCell = NO;
    
    cell.category = [self categoryAtIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FUCategory *selectedCategory = [self categoryAtIndexPath:indexPath];
    
    if (selectedCategory.hasChildren) {
        FUCategoriesViewController *categoriesViewController = [[FUCategoriesViewController alloc] initWithCategories:selectedCategory.children selectedCategory:selectedCategory];
            
        [self.navigationController pushViewController:categoriesViewController animated:YES];
    } else {
        [FUProductManager sharedManager].category = selectedCategory;
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Private

- (void)setupAutoCompleteTextField
{
    self.searchTextField.showTextFieldDropShadowWhenAutoCompleteTableIsOpen = NO;
    self.searchTextField.maximumNumberOfAutoCompleteRows = 7;
    self.searchTextField.reverseAutoCompleteSuggestionsBoldEffect = YES;

    self.searchTextField.autoCompleteTableCornerRadius = 0;
    self.searchTextField.autoCompleteDataSource = self;
    self.searchTextField.autoCompleteDelegate = self;
    self.searchTextField.autoCompleteRegularFontName = FUFontSearchListRegular.fontName;
    self.searchTextField.autoCompleteBoldFontName = FUFontSearchListBold.fontName;
    self.searchTextField.autoCompleteFontSize = 14;
    self.searchTextField.autoCompleteTableCellTextColor = FUColorLightGray;
    self.searchTextField.autoCompleteTableCellBackgroundColor = [UIColor whiteColor];
    self.searchTextField.autoCompleteTableBorderColor = FUColorOrange;
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField willShowAutoCompleteTableView:(UITableView *)autoCompleteTableView
{
    self.categoriesTableViewTopConstraint.constant = autoCompleteTableView.frame.origin.y +  autoCompleteTableView.frame.size.height + 20;

    [UIView animateWithDuration:0.35f animations:^{
        [self.view layoutIfNeeded];
    }];
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
