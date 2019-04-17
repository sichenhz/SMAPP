//
//  SMButton.m
//  SMAPP
//
//  Created by Jason on 17/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMButton.h"
#import "UIView+Extention.h"
#import "Const.h"

@implementation SMButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.adjustsImageWhenHighlighted = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.imageView.image && self.titleLabel.text) {
        self.imageView.centerX = self.frame.size.width - self.imageView.frame.size.width;
        self.titleLabel.centerX = self.frame.size.width / 2;
        self.titleLabel.left = 0;
        self.titleLabel.width = self.frame.size.width;
    }
}

@end
