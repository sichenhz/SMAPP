//
//  SMTableViewCell.m
//  SMAPP
//
//  Created by Sichen on 5/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMTableViewCell.h"
#import "Const.h"
#import "Masonry.h"

@implementation SMTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.font = FONT_BODY;
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
        make.top.right.bottom.equalTo(rightLabel.superview);
    }];
    _rightLabel = rightLabel;

}

@end
