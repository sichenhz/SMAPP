//
//  SMHomeTableViewCell.m
//  SMAPP
//
//  Created by Sichen on 14/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMHomeTableViewCell.h"
#import "Const.h"
#import "Masonry.h"

@implementation SMHomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.clipsToBounds = YES;
        self.backgroundColor = COLOR_BACKGROUND_DARK;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"location_gray"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"location_red"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(button.superview);
        make.width.equalTo(button.mas_height);
    }];
    _button = button;
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.font = FONT_BODY;
    leftLabel.textColor = COLOR_TITLE;
    [self.contentView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button.mas_right);
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

- (void)buttonPressed:(UIButton *)sender {
    sender.selected = !sender.isSelected;

    if (self.buttonPressed) {
        self.buttonPressed(sender);
    }
}

- (void)setAvailable:(BOOL)available {
    _available = available;
    
    if (available) {
        self.rightLabel.text = @"Available";
        self.rightLabel.textColor = HEXCOLOR(0x2E6C49);
    } else {
        self.rightLabel.text = @"Not Available";
        self.rightLabel.textColor = HEXCOLOR(0xFF0000);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.accessoryView) {
            make.right.equalTo(self.rightLabel.superview).offset(-10);
        } else {
            make.right.equalTo(self.rightLabel.superview);
        }
    }];
}

@end
