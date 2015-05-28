//
//  FUFilterPriceViewController.m
//  furn
//
//  Created by Stephan Krusche on 26/04/15.
//
//

#import "FUFilterPriceViewController.h"
#import "FUFilterManager.h"
#import <NMRangeSlider.h>
#import "FUFontConstants.h"
#import "FUColorConstants.h"

@interface FUFilterPriceViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIButton *applyFilterButton;
@property (weak, nonatomic) IBOutlet UITextField *minPriceField;
@property (weak, nonatomic) IBOutlet UITextField *maxPriceField;
@property (weak, nonatomic) IBOutlet NMRangeSlider *priceRangeSlider;

@property (strong, nonatomic) NSArray* filterItemKeys;
@property (nonatomic, strong) NSMutableDictionary *currentFilterItems;

@end

@implementation FUFilterPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.applyFilterButton.layer.borderWidth = 1.5f;
    self.applyFilterButton.layer.borderColor = [[UIColor colorWithRed:244.0/255.0 green:170.0/255.0 blue:56.0/255.0 alpha:1.0] CGColor];
    
    self.minPriceField.layer.borderWidth = 1.5f;
    self.minPriceField.layer.borderColor = [[UIColor colorWithRed:170/255.0 green:170.0/255.0 blue:170/255.0 alpha:1.0] CGColor];
    self.minPriceField.delegate = self;
    [self.minPriceField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.maxPriceField.layer.borderWidth = 1.5f;
    self.maxPriceField.layer.borderColor = [[UIColor colorWithRed:170/255.0 green:170.0/255.0 blue:170/255.0 alpha:1.0] CGColor];
    self.maxPriceField.delegate = self;
    [self.maxPriceField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneClicked:)];
    [keyboardDoneButtonView setItems:@[doneButton]];
    self.minPriceField.inputAccessoryView = keyboardDoneButtonView;
    self.maxPriceField.inputAccessoryView = keyboardDoneButtonView;
    
    self.priceRangeSlider.minimumValue = [FUMinPriceDefaultValue floatValue];
    self.priceRangeSlider.maximumValue = [FUMaxPriceDefaultValue floatValue];
    self.priceRangeSlider.stepValue = 10;
    self.priceRangeSlider.stepValueContinuously = NO;
    self.priceRangeSlider.trackImage = [UIImage imageNamed:@"slider-orange-track"];
    self.priceRangeSlider.lowerHandleImageNormal = [UIImage imageNamed:@"min"];
    self.priceRangeSlider.lowerHandleImageHighlighted = [UIImage imageNamed:@"min"];
    self.priceRangeSlider.upperHandleImageNormal = [UIImage imageNamed:@"max"];
    self.priceRangeSlider.upperHandleImageHighlighted = [UIImage imageNamed:@"max"];
    
    self.priceRangeSlider.backgroundColor = [UIColor clearColor];
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
    
    [self updateFields];
    [self updateRangeSlider];
}

- (void) updateRangeSlider {
    //we need to set it twice, other it does not work in certain cases
    self.priceRangeSlider.lowerValue = [self.currentFilterItems[FUMinPriceKey] integerValue];
    self.priceRangeSlider.upperValue = [self.currentFilterItems[FUMaxPriceKey] integerValue];
    self.priceRangeSlider.lowerValue = [self.currentFilterItems[FUMinPriceKey] integerValue];
    self.priceRangeSlider.upperValue = [self.currentFilterItems[FUMaxPriceKey] integerValue];
}

- (void)updateFields {
    
    self.minPriceField.text = [NSString stringWithFormat:@"$%@", [self.currentFilterItems[FUMinPriceKey] stringValue]];
    self.maxPriceField.text = [NSString stringWithFormat:@"$%@", [self.currentFilterItems[FUMaxPriceKey] stringValue]];
    
    if([self.currentFilterItems[FUMinPriceKey] integerValue] > [FUMinPriceDefaultValue integerValue]) {
        //BOLD and ORANGE
        self.minPriceField.font = FUFontAvenirBold(17);
        self.minPriceField.textColor = FUColorOrange;
    }
    else {
        //MEDIUM and LIGHT GREY
        self.minPriceField.font = FUFontAvenirLight(17);
        self.minPriceField.textColor = FUColorDarkGray;
    }
    
    if([self.currentFilterItems[FUMaxPriceKey] integerValue] < [FUMaxPriceDefaultValue integerValue]) {
        //BOLD and ORANGE
        self.maxPriceField.font = FUFontAvenirBold(17);
        self.maxPriceField.textColor = FUColorOrange;
    }
    else {
        //MEDIUM and LIGHT GREY
        self.maxPriceField.font = FUFontAvenirLight(17);
        self.maxPriceField.textColor = FUColorDarkGray;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)applyFilter:(id)sender {
    for(NSString *filterItemKey in self.filterItemKeys) {
        // save all current filters to the previous list owned by FUFilterViewController
        self.previousFilterItems[filterItemKey] = self.currentFilterItems[filterItemKey];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)removeFilter:(id)sender {
    self.currentFilterItems[FUMinPriceKey] = FUMinPriceDefaultValue;
    self.currentFilterItems[FUMaxPriceKey] = FUMaxPriceDefaultValue;
    [self updateFields];
    [self updateRangeSlider];
}

- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sliderValueChanged:(NMRangeSlider*)slider{

    self.currentFilterItems[FUMinPriceKey] = @((int)slider.lowerValue);
    self.currentFilterItems[FUMaxPriceKey] = @((int)slider.upperValue);
    
    [self updateFields];
}

#pragma mark - UITextFieldDelegate

- (void)doneClicked:(id)sender
{
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldEditingChanged:(UITextField *)textField
{
    NSString *value = [textField.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
    if (textField == self.minPriceField) {
        long lowerValue = MIN(value.integerValue, self.priceRangeSlider.upperValue);
        [self.priceRangeSlider setLowerValue:lowerValue animated:YES];
        self.currentFilterItems[FUMinPriceKey] = @(lowerValue);
        
    }
    else if (textField == self.maxPriceField) {
        long upperValue = MAX(value.integerValue, self.priceRangeSlider.lowerValue);
        [self.priceRangeSlider setUpperValue:upperValue animated:YES];
        self.currentFilterItems[FUMaxPriceKey] = @(upperValue);
    }
    
    [self updateFields];
}

@end
