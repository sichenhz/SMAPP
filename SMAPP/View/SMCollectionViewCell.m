//
//  SMCollectionViewCell.m
//  SMAPP
//
//  Created by Jason on 7/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMCollectionViewCell.h"
#import "Const.h"
#import "Masonry.h"

@implementation SMCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = HEXCOLOR(0xF0F8FF);
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    UILabel *topLabel = [[UILabel alloc] init];
    [self.contentView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(topLabel.superview).offset(10);
        make.right.equalTo(topLabel.superview).offset(-10);
    }];
    topLabel.font = FONT_BODY;
    topLabel.numberOfLines = 0;
    _topLabel = topLabel;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftButton.superview).offset(5);
        make.bottom.equalTo(leftButton.superview).offset(-5);
        make.width.height.equalTo(@25);
    }];
    [leftButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(rightButton.superview).offset(-5);
        make.width.height.equalTo(@25);
    }];
    [rightButton setImage:[UIImage imageNamed:@"Goods-details_delete"] forState:UIControlStateNormal];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(imageView.superview);
        make.height.equalTo(imageView.superview).dividedBy(3);
    }];
    imageView.backgroundColor = RandomColor;
    _imageView = imageView;
}

@end
