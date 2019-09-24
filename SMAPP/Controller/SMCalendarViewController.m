//
//  SMCalendarViewController.m
//  SMAPP
//
//  Created by Jason on 18/9/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMCalendarViewController.h"
#import "Masonry.h"
#import "Const.h"

@interface SMCalendarViewController ()

@end

@implementation SMCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_BACKGROUND;
    self.title = @"Calendar";
    
    UILabel *label = [[UILabel alloc] init];
    label.font = FONT_H1_BOLD;
    label.textColor = COLOR_ORANGE;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-50);
    }];
    label.text = @"Under Construction";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
