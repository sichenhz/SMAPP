//
//  SMTextFieldTableViewCell.m
//  SMAPP
//
//  Created by Jason on 15/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMTextFieldTableViewCell.h"
#import "Const.h"
#import "Masonry.h"

@implementation SMTextFieldTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = COLOR_BACKGROUND_DARK;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    UITextField *textField = [[UITextField alloc] init];
    textField.font = FONT_BODY;
    textField.textColor = COLOR_TITLE;
    [self.contentView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textField.superview).offset(15);
        make.top.bottom.equalTo(textField.superview);
        make.right.equalTo(textField.superview).offset(-15);
    }];
    _textField = textField;
}

@end
