//
//  SMCollectionViewCell.m
//  SMAPP
//
//  Created by Sichen on 7/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMCollectionViewCell.h"
#import "Const.h"
#import "Masonry.h"
#import "SMService.h"
#import <HomeKit/HomeKit.h>

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
    topLabel.textColor = COLOR_TITLE;
    topLabel.numberOfLines = 2;
    _topLabel = topLabel;
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:editButton];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(editButton.superview);
        make.width.height.equalTo(@35);
    }];
    [editButton setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:removeButton];
    [removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(removeButton.superview);
        make.width.height.equalTo(@35);
    }];
    [removeButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [removeButton addTarget:self action:@selector(removeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:iconButton];
    [iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(iconButton.superview);
        make.height.equalTo(iconButton.superview).dividedBy(3);
    }];
    iconButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [iconButton addTarget:self action:@selector(iconButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _iconButton = iconButton;
}

- (void)setServiceType:(NSString *)serviceType {
    _serviceType = serviceType;
    
    SMServiceType type = [SMService typeWithTypeString:serviceType];
    
    if (type == SMServiceTypeBulb) {
        self.cellType = SMCollectionViewCellTypeBulb;
        if (self.iconButton.isSelected) {
            [self.iconButton setImage:[UIImage imageNamed:@"bulb_on"] forState:UIControlStateSelected];
        } else {
            [self.iconButton setImage:[UIImage imageNamed:@"bulb_off"] forState:UIControlStateNormal];
        }
    } else if (type == SMServiceTypeSwitch) {
        self.cellType = SMCollectionViewCellTypeSwitch;
        if (self.iconButton.isSelected) {
            [self.iconButton setImage:[UIImage imageNamed:@"placeholder_on"] forState:UIControlStateSelected];
        } else {
            [self.iconButton setImage:[UIImage imageNamed:@"placeholder_off"] forState:UIControlStateNormal];
        }
    } else if (type == SMServiceTypeSensor) {
        self.cellType = SMCollectionViewCellTypeSensor;
        [self.iconButton setImage:[UIImage imageNamed:@"sensor"] forState:UIControlStateNormal];
    }
}

#pragma mark - Action

- (void)iconButtonPressed:(id)sender {
    if (self.iconButtonPressed) {
        self.iconButtonPressed(sender);
    }
}

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

