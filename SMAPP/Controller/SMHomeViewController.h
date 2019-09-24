//
//  SMHomeViewController.h
//  SMAPP
//
//  Created by Sichen on 14/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHomeManager+Share.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMHomeViewController : UITableViewController

- (void)switchHome:(id)sender;
- (void)updatePrimaryHome:(HMHome *)home;

@end

NS_ASSUME_NONNULL_END
