//
//  FUAlertView.h
//  furn
//
//  Created by Markus Bösch on 01/05/15.
//

#import <UIKit/UIKit.h>

@class FUAlertView;

@protocol FUAlertViewDelegate <NSObject>

- (void)alertViewConfirm:(FUAlertView *)alertView;

- (void)alertViewCancel:(FUAlertView *)alertView;

- (void)alertViewClose:(FUAlertView *)alertView;

@end


@interface FUAlertView : UIAlertView

@property (nonatomic, assign) id<FUAlertViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id<FUAlertViewDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
           confirmButtonTitle:(NSString *)confirmButtonTitle;

- (void)show:(BOOL)animated;

- (void)hide:(BOOL)animated;

@end
