//
//  FUFilterDetailViewController.h
//  furn
//
//  Created by Stephan Krusche on 26/04/15.
//
//

#import <UIKit/UIKit.h>

#import <GAI.h>

@interface FUFilterDetailViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *previousFilterItems;
@property (nonatomic, strong) NSString *name;

@end
