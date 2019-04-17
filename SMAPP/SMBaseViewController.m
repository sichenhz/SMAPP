//
//  SMBaseViewController.m
//  SMAPP
//
//  Created by Jason on 17/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMBaseViewController.h"

@interface SMBaseViewController ()

@end

@implementation SMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
}

- (void)initNavigationItemWithLeftTitle:(NSString *)title {
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD}];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonItemPressed:)];
    [leftButtonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : HEXCOLOR(0xFFA500)} forState:(UIControlStateNormal)];
    [leftButtonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : HEXCOLOR(0xFFA500)} forState:(UIControlStateHighlighted)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;

    UIBarButtonItem *rightbuttonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add Accessory" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemPressed:)];
    [rightbuttonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : HEXCOLOR(0xFFA500)} forState:(UIControlStateNormal)];
    [rightbuttonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : HEXCOLOR(0xFFA500)} forState:(UIControlStateHighlighted)];
    self.navigationItem.rightBarButtonItem = rightbuttonItem;
}

- (void)initHeaderViewWithCompletionHandler:(void (^)(UIButton *leftButton, UIButton *rightButton))completion {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 120, 44)];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton setTitleColor:HEXCOLOR(0xFFA500) forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [leftButton.titleLabel setFont:FONT_H2_BOLD];
    [headerView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(headerView.width - 135, 10, 120, 44)];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton setTitleColor:HEXCOLOR(0xFFA500) forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:FONT_H2_BOLD];
    [headerView addSubview:rightButton];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, self.view.width - 30, 20)];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = FONT_BODY;
    [headerView addSubview:textLabel];
    self.textLabel = textLabel;

    self.tableView.tableHeaderView = headerView;
    
    completion(leftButton, rightButton);
}

#pragma mark - Actions

- (void)leftButtonItemPressed:(id)sender {
}

- (void)rightButtonItemPressed:(id)sender {
}

@end
