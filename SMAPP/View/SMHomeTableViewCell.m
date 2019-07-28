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
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.font = FONT_BODY;
    leftLabel.textColor = COLOR_TITLE;
    [self.contentView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel.superview).offset(15);
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
