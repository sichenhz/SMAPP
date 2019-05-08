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
    topLabel.numberOfLines = 2;
    _topLabel = topLabel;
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:editButton];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(editButton.superview).offset(5);
        make.bottom.equalTo(editButton.superview).offset(-5);
        make.width.height.equalTo(@25);
    }];
    [editButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:removeButton];
    [removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(removeButton.superview).offset(-5);
        make.width.height.equalTo(@25);
    }];
    [removeButton setImage:[UIImage imageNamed:@"Goods-details_delete"] forState:UIControlStateNormal];
    [removeButton addTarget:self action:@selector(removeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(imageView.superview);
        make.height.equalTo(imageView.superview).dividedBy(3);
    }];
    imageView.backgroundColor = RandomColor;
    _imageView = imageView;
}

#pragma mark - Action

- (void)editButtonPressed:(id)sender {
    if (self.editButtonPressed) {
        self.editButtonPressed();
    }
}

- (void)removeButtonPressed:(id)sender {
    if (self.removeButtonPressed) {
        self.removeButtonPressed();
    }
}


@end

