//
//  SMTableViewHeaderView.m
//  SMAPP
//
//  Created by Sichen on 5/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMTableViewHeaderView.h"
#import "Const.h"
#import "Masonry.h"
#import "UIView+Extention.h"

@implementation SMTableViewHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {

    UIButton *arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    arrowButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    arrowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.contentView addSubview:arrowButton];
    [arrowButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [arrowButton setImage:[UIImage imageNamed:@"arrow-drop-down"] forState:UIControlStateSelected];
    [arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(arrowButton.superview);
    }];
    [arrowButton addTarget:self action:@selector(arrowButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _arrowButton = arrowButton;
    
    UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    switchButton.hidden = YES;
    switchButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    switchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.contentView addSubview:switchButton];
    [switchButton setImage:[UIImage imageNamed:@"favourite"] forState:UIControlStateNormal];
    [switchButton setImage:[UIImage imageNamed:@"favourite_selected"] forState:UIControlStateSelected];
    [switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(switchButton.superview);
    }];
    [switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _switchButton = switchButton;
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    titleButton.titleLabel.font = FONT_BODY_BOLD;
    [titleButton setTitleColor:COLOR_TITLE forState:UIControlStateNormal];
    [self.contentView addSubview:titleButton];
    [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(titleButton.superview);
    }];
    [titleButton addTarget:self action:@selector(titleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _titleButton = titleButton;

    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = COLOR_LINE;
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(bottomLine.superview);
        make.height.equalTo(@0.5);
    }];
}

- (void)switchButtonPressed:(UIButton *)sender {
    if (self.switchButtonPressed) {
        self.switchButtonPressed(sender);
    }
}

- (void)arrowButtonPressed:(UIButton *)sender {
    if (self.arrowButtonPressed) {
        self.arrowButtonPressed(sender);
    }
}

- (void)titleButtonPressed:(UIButton *)sender {
    if (self.titleButtonPressed) {
        self.titleButtonPressed();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = [self.titleButton sizeThatFits:CGSizeMake(MAXFLOAT, self.height)].width;
    [self.titleButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width + self.titleButton.titleEdgeInsets.left + self.titleButton.titleEdgeInsets.right));
    }];
}

@end
