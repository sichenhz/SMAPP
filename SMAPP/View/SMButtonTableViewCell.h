//
//  SMButtonTableViewCell.h
//  SMAPP
//
//  Created by Sichen on 15/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMButtonTableViewCell : UITableViewCell

@property (nonatomic, weak, readonly) UIButton *button;
@property (nonatomic, copy) void(^cellPressed)(void);

@end

NS_ASSUME_NONNULL_END
