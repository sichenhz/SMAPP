//
//  SMRoomTableViewCell.m
//  SMAPP
//
//  Created by Sichen on 14/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMRoomTableViewCell.h"
#import "Const.h"
#import "Masonry.h"

@implementation SMRoomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.clipsToBounds = YES;
        self.backgroundColor = COLOR_BACKGROUND;
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
}


@end
