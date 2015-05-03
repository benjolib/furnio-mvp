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

@interface FUFilterPriceViewController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIButton *applyFilterButton;
@property (weak, nonatomic) IBOutlet UILabel *minPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxPriceLabel;
@property (weak, nonatomic) IBOutlet NMRangeSlider *priceRangeSlider;

@property (strong, nonatomic) NSArray* filterItemKeys;
@property (nonatomic, strong) NSMutableDictionary *currentFilterItems;

@end

@implementation FUFilterPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.applyFilterButton.layer.borderWidth = 1.5f;
    self.applyFilterButton.layer.borderColor = [[UIColor colorWithRed:244.0/255.0 green:170.0/255.0 blue:56.0/255.0 alpha:1.0] CGColor];
    
    self.minPriceLabel.layer.borderWidth = 1.5f;
    self.minPriceLabel.layer.borderColor = [[UIColor colorWithRed:170/255.0 green:170.0/255.0 blue:170/255.0 alpha:1.0] CGColor];

    self.maxPriceLabel.layer.borderWidth = 1.5f;
    self.maxPriceLabel.layer.borderColor = [[UIColor colorWithRed:170/255.0 green:170.0/255.0 blue:170/255.0 alpha:1.0] CGColor];
    
    self.priceRangeSlider.minimumValue = [FUMinPriceDefaultValue floatValue];
    self.priceRangeSlider.maximumValue = [FUMaxPriceDefaultValue floatValue];
    self.priceRangeSlider.stepValue = 10;
    self.priceRangeSlider.stepValueContinuously = NO;
    self.priceRangeSlider.trackImage = [UIImage imageNamed:@"slider-orange-track"];

    //TODO: set lower handle image and upper handle image if the assets are available
    
    self.priceRangeSlider.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
    
    self.navItem.title = self.name;
    
    self.currentFilterItems = [self.previousFilterItems mutableCopy];
    self.filterItemKeys = [[self.currentFilterItems allKeys] sortedArrayUsingSelector: @selector(localizedCompare:)];
    
    [self updateLabels];
    [self updateRangeSlider];
}

- (void) updateRangeSlider {
    //we need to set it twice, other it does not work in certain cases
    self.priceRangeSlider.lowerValue = [self.currentFilterItems[FUMinPriceKey] integerValue];
    self.priceRangeSlider.upperValue = [self.currentFilterItems[FUMaxPriceKey] integerValue];
    self.priceRangeSlider.lowerValue = [self.currentFilterItems[FUMinPriceKey] integerValue];
    self.priceRangeSlider.upperValue = [self.currentFilterItems[FUMaxPriceKey] integerValue];
}

- (void)updateLabels {
    
    self.minPriceLabel.text = [NSString stringWithFormat:@"$%@", [self.currentFilterItems[FUMinPriceKey] stringValue]];
    self.maxPriceLabel.text = [NSString stringWithFormat:@"$%@", [self.currentFilterItems[FUMaxPriceKey] stringValue]];
    
    if([self.currentFilterItems[FUMinPriceKey] integerValue] > [FUMinPriceDefaultValue integerValue]) {
        //BOLD and ORANGE
        self.minPriceLabel.font = FUFontAvenirBold(17);
        self.minPriceLabel.textColor = FUColorOrange;
    }
    else {
        //MEDIUM and LIGHT GREY
        self.minPriceLabel.font = FUFontAvenirLight(17);
        self.minPriceLabel.textColor = FUColorLightGray;
    }
    
    if([self.currentFilterItems[FUMaxPriceKey] integerValue] < [FUMaxPriceDefaultValue integerValue]) {
        //BOLD and ORANGE
        self.maxPriceLabel.font = FUFontAvenirBold(17);
        self.maxPriceLabel.textColor = FUColorOrange;
    }
    else {
        //MEDIUM and LIGHT GREY
        self.maxPriceLabel.font = FUFontAvenirLight(17);
        self.maxPriceLabel.textColor = FUColorLightGray;
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
    //TODO use default values of FUFilterManager
    self.currentFilterItems[FUMinPriceKey] = FUMinPriceDefaultValue;
    self.currentFilterItems[FUMaxPriceKey] = FUMaxPriceDefaultValue;
    [self updateLabels];
    [self updateRangeSlider];
}

- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sliderValueChanged:(NMRangeSlider*)slider{

    self.currentFilterItems[FUMinPriceKey] = @((int)slider.lowerValue);
    self.currentFilterItems[FUMaxPriceKey] = @((int)slider.upperValue);
    
    [self updateLabels];
}



@end
