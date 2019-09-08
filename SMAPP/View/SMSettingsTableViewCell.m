//
//  SMSettingsTableViewCell.m
//  SMAPP
//
//  Created by Jason on 5/9/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMSettingsTableViewCell.h"
#import "Masonry.h"
#import "const.h"

@implementation SMSettingsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.clipsToBounds = YES;
        self.backgroundColor = COLOR_BACKGROUND;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(iconView.superview);
        make.width.equalTo(iconView.mas_height);
    }];
    _iconView = iconView;
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.font = FONT_BODY;
    leftLabel.textColor = COLOR_TITLE;
    [self.contentView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right);
        make.top.bottom.equalTo(leftLabel.superview);
    }];
    _leftLabel = leftLabel;
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.font = FONT_BODY;
    [self.contentView addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(rightLabel.superview);
    }];
    _rightLabel = rightLabel;
}

@end
