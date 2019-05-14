//
//  SMTextViewTableViewCell.m
//  SMAPP
//
//  Created by Jason on 15/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMTextViewTableViewCell.h"
#import "Const.h"
#import "Masonry.h"

@implementation SMTextViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = COLOR_BACKGROUND_DARK;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    UITextView *textView = [[UITextView alloc] init];
    textView.font = FONT_BODY;
    textView.textColor = COLOR_TITLE;
    [self.contentView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textView.superview).offset(15);
        make.top.bottom.equalTo(textView.superview);
        make.right.equalTo(textView.superview).offset(-15);
    }];
    _textView = textView;
}

@end
