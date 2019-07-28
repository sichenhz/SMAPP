//
//  AppDelegate.m
//  SMAPP
//
//  Created by Sichen on 14/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "AppDelegate.h"
#import "Const.h"
#import "SMHomeViewController.h"
#import "SMNotificationViewController.h"
#import "SMAccessoryListViewController.h"
#import "SMSettingsViewController.h"
#import "UIView+Extention.h"
#import "Masonry.h"

@interface AppDelegate () <UITabBarControllerDelegate>

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
    
    UITabBarController *tabBarC = [[UITabBarController alloc] init];
    tabBarC.delegate = self;
    tabBarC.viewControllers = @[self.nav1_r, self.nav2_r, self.nav3_r];
        
    self.window.rootViewController = tabBarC;
    [self.window makeKeyAndVisible];
    
    tabBarC.view.left = self.window.width - WIDTH_NAV_R;
    tabBarC.view.width = WIDTH_NAV_R;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = COLOR_LINE;
    [tabBarC.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@1);
        make.top.bottom.equalTo(tabBarC.view);
        make.left.equalTo(tabBarC.view.mas_left);
    }];

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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Getters

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

//- (UINavigationController *)nav1_l {
//
//}
//
//- (UINavigationController *)nav2_l {
//
//}

- (UINavigationController *)nav3_l {
    if (!_nav3_l) {
        _nav3_l = [self setUpNavigationController:[[SMAccessoryListViewController alloc] init]
                                            title:@"My Devices"
                                        imageName:@"tabbar_profile"
                                selectedImageName:@"tabbar_profile_selected"];
        [self.window addSubview:_nav3_l.view];
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
        
    } else if ([viewController isEqual:self.nav2_r]) {

    } else if ([viewController isEqual:self.nav3_r]) {
        self.nav3_l.view.hidden = NO;
    }
}

@end
