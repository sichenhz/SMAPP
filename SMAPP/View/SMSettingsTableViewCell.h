//
//  SMSettingsTableViewCell.h
//  SMAPP
//
//  Created by Jason on 5/9/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMSettingsTableViewCell : UITableViewCell

@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *leftLabel;
@property (nonatomic, weak) UILabel *rightLabel;

@end

NS_ASSUME_NONNULL_END
