//
//  SMTableViewCell.h
//  SMAPP
//
//  Created by Sichen on 5/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMTableViewCell : UITableViewCell

@property (nonatomic, weak) UILabel *leftLabel;
@property (nonatomic, weak) UILabel *rightLabel;
@property (nonatomic, weak) UIButton *button;

@property (nonatomic, assign, getter=isAvailable) BOOL available;

@end

NS_ASSUME_NONNULL_END
