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

@implementation SMTableViewHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
        
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.titleLabel.font = FONT_BODY_BOLD;
    [titleButton setTitleColor:COLOR_TITLE forState:UIControlStateNormal];
    [self.contentView addSubview:titleButton];
    [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleButton.superview).offset(15);
        make.top.bottom.equalTo(titleButton.superview);
    }];
    [titleButton addTarget:self action:@selector(titleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _titleButton = titleButton;
    
    UIButton *arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:arrowButton];
    [arrowButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [arrowButton setImage:[UIImage imageNamed:@"arrow-drop-down"] forState:UIControlStateSelected];
    [arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(arrowButton.superview);
        make.width.equalTo(@44);
    }];
    [arrowButton addTarget:self action:@selector(arrowButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _arrowButton = arrowButton;
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = COLOR_LINE;
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(bottomLine.superview);
        make.height.equalTo(@0.5);
    }];
}

- (void)titleButtonPressed:(UIButton *)sender {
    if (self.titleButtonPressed) {
        self.titleButtonPressed();
    }
}

- (void)arrowButtonPressed:(UIButton *)sender {
    if (self.arrowButtonPressed) {
        sender.selected = !sender.isSelected;
        self.arrowButtonPressed(sender.isSelected);
    }
}

@end
