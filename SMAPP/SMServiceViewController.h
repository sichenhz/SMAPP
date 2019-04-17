//
//  SMServiceViewController.h
//  SMAPP
//
//  Created by Sichen on 14/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMServiceViewController : UITableViewController

@property (nonatomic, strong) HMService *service;

@end

NS_ASSUME_NONNULL_END
