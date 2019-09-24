//
//  SMNoFloorPlanView.m
//  SMAPP
//
//  Created by Jason on 24/9/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMNoFloorPlanView.h"
#import "Const.h"
#import "Masonry.h"

@implementation SMNoFloorPlanView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = COLOR_BACKGROUND;
        
        UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        homeButton.hidden = YES;
        [homeButton setImage:[UIImage imageNamed:@"home_large"] forState:UIControlStateNormal];
        [self addSubview:homeButton];
        [homeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(30);
            make.width.height.equalTo(@60);
        }];
        _homeButton = homeButton;

        UIButton *albumsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        albumsButton.hidden = YES;
        [albumsButton setImage:[UIImage imageNamed:@"album"] forState:UIControlStateNormal];
        [self addSubview:albumsButton];
        [albumsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(-50);
            make.centerY.equalTo(self).offset(30);
            make.width.height.equalTo(@60);
        }];
        _albumsButton = albumsButton;
        
        UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraButton.hidden = YES;
        [cameraButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        [self addSubview:cameraButton];
        [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(50);
            make.centerY.equalTo(self).offset(30);
            make.width.height.equalTo(@60);
        }];
        _cameraButton = cameraButton;

        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT_H1;
        label.textColor = [UIColor blackColor];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(albumsButton.mas_top).offset(-15);
            make.centerX.equalTo(self);
            make.width.equalTo(@500);
        }];
        _label = label;
        
    }
    return self;
}

@end
