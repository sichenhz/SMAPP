//
//  SMAccessoryViewController.h
//  SMAPP
//
//  Created by Sichen on 14/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMAccessoryDetailViewController : UITableViewController

@property (strong, nonatomic) HMAccessory *accessory;

@end

NS_ASSUME_NONNULL_END
