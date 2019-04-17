//
//  SMAddAccessoryViewController.h
//  SMAPP
//
//  Created by Sichen on 14/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMAddAccessoryViewController : UITableViewController

- (instancetype)initWithHomeManager:(HMHomeManager *)homeManager;

@property (nonatomic, copy) void(^didAddAccessory)(void);

@end

NS_ASSUME_NONNULL_END
