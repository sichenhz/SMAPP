//
//  AppDelegate.m
//  SMAPP
//
//  Created by Sichen on 14/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "AppDelegate.h"
#import "Const.h"
#import "SMMainViewController.h"
#import "SMHomeViewController.h"
#import "SMNotificationViewController.h"
#import "SMAccessoryListViewController.h"
#import "SMSettingsViewController.h"
#import "UIView+Extention.h"
#import "Masonry.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@property (nonatomic, strong) UIViewController *container;
@property (nonatomic, strong) UITabBarController *tabBarC;

@property (nonatomic, strong) UINavigationController *nav1_r;
@property (nonatomic, strong) UINavigationController *nav2_r;
@property (nonatomic, strong) UINavigationController *nav3_r;

@property (nonatomic, strong) UINavigationController *nav1_l;
@property (nonatomic, strong) UINavigationController *nav2_l;
@property (nonatomic, strong) UINavigationController *nav3_l;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.container;
    [self.window makeKeyAndVisible];
    
    [self tabBarC];
    [self nav1_l];

    return YES;
}

- (UINavigationController *)setUpNavigationController:(UIViewController *)controller
                                                title:(NSString *)title
                                            imageName:(NSString *)imageName
                                    selectedImageName:(NSString *)selectedImageName {
    
    [controller.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : FONT_BODY, NSForegroundColorAttributeName : COLOR_ORANGE} forState:UIControlStateSelected];
    [controller.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : FONT_BODY, NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateNormal];
    
    controller.tabBarItem.title = title;
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return [[UINavigationController alloc] initWithRootViewController:controller];
}

#pragma mark - Getters

- (UIViewController *)container {
    if (!_container) {
        _container = [[UIViewController alloc] init];
    }
    return _container;
}

- (UITabBarController *)tabBarC {
    if (!_tabBarC) {
        _tabBarC = [[UITabBarController alloc] init];
        [self.container addChildViewController:_tabBarC];
        [self.container.view addSubview:_tabBarC.view];
        _tabBarC.view.left = self.window.width - WIDTH_NAV_R;
        _tabBarC.view.width = WIDTH_NAV_R;

        UIView *line = [[UIView alloc] init];
        [_tabBarC.view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@1);
            make.top.bottom.equalTo(line.superview);
            make.left.equalTo(line.superview.mas_left);
        }];
        line.backgroundColor = COLOR_LINE;

        _tabBarC.delegate = self;
        _tabBarC.viewControllers = @[self.nav1_r, self.nav2_r, self.nav3_r];
    }
    return _tabBarC;
}

- (UINavigationController *)nav1_r {
    if (!_nav1_r) {
        _nav1_r = [self setUpNavigationController:[[SMHomeViewController alloc] init]
                                            title:@"home"
                                        imageName:@"tabbar_home"
                                selectedImageName:@"tabbar_home_selected"];
    }
    return _nav1_r;
}

- (UINavigationController *)nav2_r {
    if (!_nav2_r) {
        _nav2_r = [self setUpNavigationController:[[SMNotificationViewController alloc] init]
                                            title:@"Notifications"
                                        imageName:@"tabbar_message_center"
                                selectedImageName:@"tabbar_message_center_selected"];
    }
    return _nav2_r;
}

- (UINavigationController *)nav3_r {
    if (!_nav3_r) {
        _nav3_r = [self setUpNavigationController:[[SMSettingsViewController alloc] init]
                                            title:@"Settings"
                                        imageName:@"tabbar_profile"
                                selectedImageName:@"tabbar_profile_selected"];
    }
    return _nav3_r;
}

- (UINavigationController *)nav1_l {
    if (!_nav1_l) {
        _nav1_l = [[UINavigationController alloc] initWithRootViewController:[[SMMainViewController alloc] init]];
        [self.container addChildViewController:_nav1_l];
        [self.container.view addSubview:_nav1_l.view];
        _nav1_l.view.width = self.window.width - WIDTH_NAV_R;
    }
    return _nav1_l;
}

- (UINavigationController *)nav2_l {
    if (!_nav2_l) {
        _nav2_l = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
        [self.container addChildViewController:_nav2_l];
        [self.container.view addSubview:_nav2_l.view];
        _nav2_l.view.width = self.window.width - WIDTH_NAV_R;
    }
    return _nav2_l;
}

- (UINavigationController *)nav3_l {
    if (!_nav3_l) {
        _nav3_l = [[UINavigationController alloc] initWithRootViewController:[[SMAccessoryListViewController alloc] init]];
        [self.container addChildViewController:_nav3_l];
        [self.container.view addSubview:_nav3_l.view];
        _nav3_l.view.width = self.window.width - WIDTH_NAV_R;
    }
    return _nav3_l;
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    self.nav1_l.view.hidden = YES;
    self.nav2_l.view.hidden = YES;
    self.nav3_l.view.hidden = YES;
    
    if ([viewController isEqual:self.nav1_r]) {
        self.nav1_l.view.hidden = NO;
    } else if ([viewController isEqual:self.nav2_r]) {
        self.nav2_l.view.hidden = NO;
    } else if ([viewController isEqual:self.nav3_r]) {
        self.nav3_l.view.hidden = NO;
    }
}

@end
