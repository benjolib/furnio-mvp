//
//  FUOnboardingOverviewController.m
//  furn
//
//  Created by Markus Bösch on 03/05/15.
//
//

#import "FUOnboardingOverviewController.h"

#import "FUOnboardingOverviewTextCollectionViewCell.h"
#import "FUOnboardingOverviewAreaCollectionViewCell.h"

#import "UIView+Framing.h"

@interface FUOnboardingOverviewController ()

@property (assign, nonatomic) NSUInteger stepIndex;

@end

@implementation FUOnboardingOverviewController

#pragma mark - Initialization

- (instancetype)initWithStepIndex:(NSUInteger)stepIndex
{
    self = [super init];
    
    if (self) {
        self.stepIndex = stepIndex;
    }
    
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupCells];
    
    self.nextLabel.text = [self stepTitleForIndex:self.stepIndex];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0: {
            return 1;
        } break;
            
        case 1: {
            return 3;
        } break;
    }

    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.collectionView.width;
    CGFloat height = 0;

    switch (indexPath.section) {
        case 0 : {
            height = self.collectionView.height * 0.36f;
        } break;
            
        case 1: {
            height = self.collectionView.height * 0.18f;
        } break;
    }

    return CGSizeMake(width, height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            FUOnboardingOverviewTextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FUOnboardingOverviewTextCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
            
            return cell;
        } break;
            
        case 1: {
            FUOnboardingOverviewAreaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FUOnboardingOverviewAreaCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
            
            cell.done = self.stepIndex > indexPath.row;
            cell.areaName = [self areaTitleForIndexPath:indexPath];
            
            return cell;
        } break;
    }

    return nil;
}

#pragma mark - Private

- (void)setupCells
{
    [self.collectionView registerNib:[FUOnboardingOverviewTextCollectionViewCell nib] forCellWithReuseIdentifier:[FUOnboardingOverviewTextCollectionViewCell reuseIdentifier]];
    
    [self.collectionView registerNib:[FUOnboardingOverviewAreaCollectionViewCell nib] forCellWithReuseIdentifier:[FUOnboardingOverviewAreaCollectionViewCell reuseIdentifier]];
}

- (NSString *)areaTitleForIndexPath:(NSIndexPath *)indexPath
{
    static NSArray *areaTitles;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        areaTitles = @[ @"CATEGORIES", @"STYLE", @"ROOM" ];
    });
    
    NSString *areaTitle;
    
    if (indexPath.row < areaTitles.count) {
        areaTitle = [areaTitles objectAtIndex:indexPath.row];
    }
    
    return areaTitle;
}

- (NSString *)stepTitleForIndex:(NSUInteger)stepIndex
{
    static NSArray *stepTitles;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stepTitles = @[
            @"CHECK OUT OUR CATEGORIES",
            @"2ND STEP - CHOOSE YOUR STYLE",
            @"FINAL STEP - CHOOSE YOUR ROOMS"
        ];
    });
    
    NSString *stepTitle;
    
    if (stepIndex < stepTitles.count) {
        stepTitle = [stepTitles objectAtIndex:stepIndex];
    }
    
    return stepTitle;
}

@end
