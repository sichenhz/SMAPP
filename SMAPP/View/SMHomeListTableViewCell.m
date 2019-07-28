//
//  SMHomeListTableViewCell.m
//  SMAPP
//
//  Created by Sichen on 15/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMHomeListTableViewCell.h"
#import "Const.h"
#import "Masonry.h"

@implementation SMHomeListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    
    UIImage *selectedImage = [UIImage imageNamed:@"choosed"];
    UIImageView *selectedImageView = [[UIImageView alloc] initWithImage:selectedImage];
    [self.contentView addSubview:selectedImageView];
    [selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel.mas_right).offset(15);
        make.centerY.equalTo(leftLabel);
    }];
    _selectedImageView = selectedImageView;
}


@end
