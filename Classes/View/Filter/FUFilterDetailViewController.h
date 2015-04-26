//
//  FUFilterDetailViewController.h
//  furn
//
//  Created by Stephan Krusche on 26/04/15.
//
//

#import <UIKit/UIKit.h>

@interface FUFilterDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

//NSString (name) --> BOOL (activated)
@property (nonatomic, strong) NSMutableDictionary *filterItems;
@property (nonatomic, strong) NSString *name;

@end
