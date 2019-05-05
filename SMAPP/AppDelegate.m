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
#import "SMAddAccessoryViewController.h"
#import "SMNotificationViewController.h"
#import "SMSettingViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *nav1 = [self setUpNavigationController:[[SMHomeViewController alloc] init]
                                                             title:@"home"
                                                         imageName:@"tabbar_home"
                                                 selectedImageName:@"tabbar_home_selected"];
    
    UINavigationController *nav2 = [self setUpNavigationController:[[SMAddAccessoryViewController alloc] init]
                                                             title:@"Add"
                                                         imageName:@"tabbar_discover"
                                                 selectedImageName:@"tabbar_discover_selected"];
    
    UINavigationController *nav3 = [self setUpNavigationController:[[SMNotificationViewController alloc] init]
                                                             title:@"Notification"
                                                         imageName:@"tabbar_message_center"
                                                 selectedImageName:@"tabbar_message_center_selected"];
    
    UINavigationController *nav4 = [self setUpNavigationController:[[SMSettingViewController alloc] init]
                                                             title:@"Setting"
                                                         imageName:@"tabbar_profile"
                                                 selectedImageName:@"tabbar_profile_selected"];

    UITabBarController *tabBarC = [[UITabBarController alloc] init];
    tabBarC.viewControllers = @[nav1, nav2, nav3, nav4];
        
    self.window.rootViewController = tabBarC;

    [self.window makeKeyAndVisible];

    return YES;
}

- (UINavigationController *)setUpNavigationController:(UIViewController *)controller
                                                title:(NSString *)title
                                            imageName:(NSString *)imageName
                                    selectedImageName:(NSString *)selectedImageName {
    
    [controller.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : FONT_BODY, NSForegroundColorAttributeName : HEXCOLOR(0xFFA500)} forState:UIControlStateSelected];
    [controller.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : FONT_BODY, NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateNormal];
    
    controller.tabBarItem.title = title;
    controller.tabBarItem.image = [UIImage imageNamed:imageName];
    controller.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
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


@end
