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
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
        
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = FONT_BODY_BOLD;
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.superview).offset(15);
        make.top.bottom.equalTo(titleLabel.superview);
    }];
    _titleLabel = titleLabel;
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(topLine.superview);
        make.height.equalTo(@0.5);
    }];
                       
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(topLine.superview);
        make.height.equalTo(@0.5);
    }];
}

@end
