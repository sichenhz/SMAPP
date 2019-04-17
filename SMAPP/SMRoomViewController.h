//
//  SMRoomViewController.h
//  SMAPP
//
//  Created by Jason on 15/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRoomViewController : SMBaseViewController

- (instancetype)initWithHomeManager:(HMHomeManager *)homeManager;

- (void)updatePrivaryHome;

@end

NS_ASSUME_NONNULL_END
