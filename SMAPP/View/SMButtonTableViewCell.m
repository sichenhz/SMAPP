//
//  SMButtonTableViewCell.m
//  SMAPP
//
//  Created by Jason on 15/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMButtonTableViewCell.h"
#import "Const.h"
#import "Masonry.h"

@implementation SMButtonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryNone;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = FONT_H2;
    [button setTitleColor:HEXCOLOR(0xED0A0E) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(button.superview);
    }];
    _button = button;
}

- (void)buttonPressed:(id)sender {
    if (self.cellPressed) {
        self.cellPressed();
    }
}

@end
