//
//  SMHomeViewController.h
//  SMAPP
//
//  Created by Sichen on 14/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMBaseViewController.h"
#import "SMRoomViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMHomeViewController : SMBaseViewController

@property (nonatomic, weak) SMRoomViewController *roomVC;

- (instancetype)initWithHomeManager:(HMHomeManager *)homeManager;

@end

NS_ASSUME_NONNULL_END
