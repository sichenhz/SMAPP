//
//  SMBaseViewController.h
//  SMAPP
//
//  Created by Jason on 17/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <HomeKit/HomeKit.h>
#import "SMAddAccessoryViewController.h"
#import "SMAccessoryDetailViewController.h"
#import "SMAlertView.h"
#import "UIView+Extention.h"
#import "Const.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMBaseViewController : UITableViewController

@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, weak) UILabel *textLabel;
@property (nonatomic, copy) void(^didAddAccessory)(void);

- (void)initNavigationItemWithLeftTitle:(NSString *)title;
- (void)initHeaderViewWithCompletionHandler:(void (^)(UIButton *leftButton, UIButton *rightButton))completion;

// Over load
- (void)leftButtonItemPressed:(id)sender;
- (void)rightButtonItemPressed:(id)sender;

@end

NS_ASSUME_NONNULL_END
