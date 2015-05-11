//
//  FUTutorialViewController.m
//  furn
//
//  Created by Markus Bösch on 10/05/15.
//
//

#import "FUTutorialViewController.h"

#import "FUColorConstants.h"
#import "UIView+Framing.h"
#import "UIImage+Additions.h"

@interface FUTutorialViewController ()

@property (strong, nonatomic) UIImage *backgroundImage;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIImageView *forwardArrow;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (strong, nonatomic) CAShapeLayer *blurFilterMask;

@property (strong, nonatomic) NSArray *circleOrigins;
@property (strong, nonatomic) NSArray *arrows;
@property (strong, nonatomic) NSArray *texts;
@property (strong, nonatomic) NSString *finishedSuffix;

@property (strong, nonatomic) NSMutableArray *arrowImageViews;

@property (assign, nonatomic) NSUInteger stepCount;

@property (assign, nonatomic) NSUInteger currentStep;

@property (strong, nonatomic) NSMutableArray *subLayers;

@end

@implementation FUTutorialViewController

#pragma mark - Initialization

- (instancetype)initWithBackgroundView:(UIView *)view circleOrigins:(NSArray *)circleOrigins arrows:(NSArray *)arrows texts:(NSArray *)texts finishedSuffix:(NSString *)finishedSuffix
{
    NSParameterAssert(view);
    NSParameterAssert(circleOrigins);
    NSParameterAssert(arrows);
    NSParameterAssert(texts);
    NSParameterAssert(finishedSuffix);

    NSAssert(circleOrigins.count == arrows.count && arrows.count == texts.count, @"circle count must match arrow count as well as texts count.");
    
    self = [super init];

    if (self) {
        self.backgroundImage = [self imageFromView:view];

        self.circleOrigins = circleOrigins;
        self.arrows = arrows;
        self.texts = texts;
        self.finishedSuffix = finishedSuffix;
        
        self.stepCount = circleOrigins.count;
    }

    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.forwardArrow.image = [self.forwardArrow.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.backgroundImageView.image = self.backgroundImage;
    
    [self setupNextButton];
    
    [self setupStep];
}

#pragma mark - Setup

- (void)setupNextButton
{
    self.nextButton.layer.borderColor = FUColorOrange.CGColor;
    self.nextButton.layer.borderWidth = 1;
    
    [self.nextButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:self.nextButton.size] forState:UIControlStateNormal];
    
    [self.nextButton setBackgroundImage:[UIImage imageWithColor:FUColorOrange size:self.nextButton.size] forState:UIControlStateHighlighted];
}

- (void)setupStep
{
    [self setupCircles];
    [self setupArrows];
    [self setupTextLabel];
}

- (void)setupCircles
{
    if (!self.subLayers) {
        self.subLayers = [NSMutableArray array];
    } else {
        for (CALayer *layer in self.subLayers) {
            [layer removeFromSuperlayer];
        }
        
        [self.subLayers removeAllObjects];
    }
    
    NSValue *originValue = [self.circleOrigins objectAtIndex:self.currentStep];
    
    CGPoint origin = originValue.CGPointValue;

    CAShapeLayer *blurFilterMask = [CAShapeLayer layer];
    
    // Disable implicit animations for the blur filter mask's path property.
    blurFilterMask.actions = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"path", nil];
    blurFilterMask.fillColor = [UIColor blackColor].CGColor;
    blurFilterMask.fillRule = kCAFillRuleEvenOdd;
    blurFilterMask.frame = self.backgroundImageView.bounds;
    blurFilterMask.opacity = 0.75f;
    
    
    CGMutablePathRef blurRegionPath = CGPathCreateMutable();
        
    CGPathAddRect(blurRegionPath, NULL, self.backgroundImageView.bounds);
    
    if (!CGPointEqualToPoint(origin, CGPointZero)) {

        CGFloat radius = 60;
        CGPathAddEllipseInRect(blurRegionPath, NULL, CGRectMake(origin.x - radius, origin.y - radius, radius * 2, radius * 2));
    }
    
    self.blurFilterMask = blurFilterMask;
    self.blurFilterMask.path = blurRegionPath;
        
    CGPathRelease(blurRegionPath);

    [self.subLayers addObject:blurFilterMask];
    
    [self.backgroundImageView.layer addSublayer:blurFilterMask];
}

- (void)setupArrows
{
    if (!self.arrowImageViews) {
        self.arrowImageViews = [NSMutableArray array];
    } else {
        for (UIImageView *arrowImageView in self.arrowImageViews) {
            [arrowImageView removeFromSuperview];
        }
        
        [self.arrowImageViews removeAllObjects];
    }

    NSNumber *arrowNumber = [self.arrows objectAtIndex:self.currentStep];
    FUTutorialViewArrow arrow = arrowNumber.integerValue;
    
    [self addArrow:arrow];
}

- (void)setupTextLabel
{
    self.textLabel.text = [self.texts objectAtIndex:self.currentStep];
}

#pragma mark - FUViewController

- (void)configureNavigationBar
{
    self.navigationBar.leftButton = nil;
}

#pragma mark - Actions

- (IBAction)nextButtonTapped:(UIButton *)sender
{
    if (self.currentStep < self.stepCount - 1) {
        self.currentStep++;
        
        [self setupStep];
        
        if (self.currentStep == self.stepCount - 1) {
            [self.nextButton setTitle:[NSString stringWithFormat:@"FINISHED. %@.", self.finishedSuffix].uppercaseString forState:UIControlStateNormal];
        }

    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Helper

-(UIImage *)imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)addArrow:(FUTutorialViewArrow)arrow
{
    UIImageView *imageView = [UIImageView new];
    NSString *imageName = @"arrow-long";
    CGRect frame = CGRectMake(0, 0, 25, 115);
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGFloat rotation = 0;
    CGFloat width = 25;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    switch (arrow) {
        case FUTutorialViewArrowTopLeft: {
            originX = 80;
            originY = 94;
            rotation = -M_PI / 6;
        } break;
            
        case FUTutorialViewArrowTopCenter: {
            originX = (screenWidth - width) / 2;
            originY = 80;
            rotation = 0;
            rotation = M_PI / 34;
        } break;
            
        case FUTutorialViewArrowTopRight: {
            originX = screenWidth - 130;
            originY = 80;
            rotation = M_PI / 5;
        } break;
            
        case FUTutorialViewArrowCenter: {
            imageName = nil; // TODO: missing asset
        } break;
            
        case FUTutorialViewArrowBottomCenter: {
            originX = (screenWidth - width) / 2;
            originY = (screenHeight - 115) / 2 + 40;
            rotation = M_PI;
        } break;
    }
    
    if (imageName) {
        imageView.image = [UIImage imageNamed:imageName];
        imageView.frame = CGRectOffset(frame, originX, originY);
        imageView.transform = CGAffineTransformMakeRotation(rotation);
    }
    
    [self.arrowImageViews addObject:imageView];
    
    [self.view addSubview:imageView];
}

@end
