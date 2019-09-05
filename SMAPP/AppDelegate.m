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

#define kTimeInterval 0.2
#define kVelocity 500.0
#define kAlpha 0.85

@interface AppDelegate () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) SMMainViewController *mainVC;
@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, assign, getter=isPoped) BOOL poped;

@property (nonatomic, strong) UINavigationController *homeVC;
@property (nonatomic, strong) UINavigationController *accessoriesVC;
@property (nonatomic, strong) UINavigationController *settingsVC;

@property (nonatomic, strong) NSMutableArray *childVCs;

@end

@implementation AppDelegate

+ (CGFloat)navigationHeight {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 70.0;
    } else {
        if ([[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0.0) {
            return 44.0;
        } else {
            return 32.0;
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.mainVC];
    
    [self homeVC];
    [self settingsVC];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - Getters

- (NSMutableArray *)childVCs {
    if (!_childVCs) {
        _childVCs = [NSMutableArray array];
    }
    return _childVCs;
}

- (SMMainViewController *)mainVC {
    if (!_mainVC) {
        _mainVC = [[SMMainViewController alloc] init];
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMenu:)];
        gesture.delegate = self;
        [_mainVC.view addGestureRecognizer:gesture];
        
        [_mainVC.titleButton addTarget:self.homeVC.childViewControllers.firstObject action:@selector(leftButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        // buttons
        UIButton *button1 = [[UIButton alloc] init];
        [button1 setBackgroundImage:[UIImage imageNamed:@"tabbar_profile"] forState:UIControlStateNormal];
        [button1 setBackgroundImage:[UIImage imageNamed:@"tabbar_profile_selected"] forState:UIControlStateSelected];
        CGRect frame = button1.frame;
        frame.size = button1.currentBackgroundImage.size;
        button1.frame = frame;
        [button1 addTarget:self action:@selector(button1Pressed:) forControlEvents:UIControlEventTouchUpInside];

        UIButton *button2 = [[UIButton alloc] init];
        [button2 setBackgroundImage:[UIImage imageNamed:@"tabbar_home"] forState:UIControlStateNormal];
        [button2 setBackgroundImage:[UIImage imageNamed:@"tabbar_home_selected"] forState:UIControlStateSelected];
        frame = button2.frame;
        frame.size = button2.currentBackgroundImage.size;
        button2.frame = frame;
        [button2 addTarget:self action:@selector(button2Pressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button3 = [[UIButton alloc] init];
        [button3 setBackgroundImage:[UIImage imageNamed:@"tabbar_discover"] forState:UIControlStateNormal];
        [button3 setBackgroundImage:[UIImage imageNamed:@"tabbar_discover_selected"] forState:UIControlStateSelected];
        frame = button3.frame;
        frame.size = button3.currentBackgroundImage.size;
        button3.frame = frame;
        [button3 addTarget:self action:@selector(button3Pressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _mainVC.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:button1],
                                                      [[UIBarButtonItem alloc] initWithCustomView:button2],
                                                      [[UIBarButtonItem alloc] initWithCustomView:button3]];
        
        button1.selected = YES;
        self.currentVC = self.settingsVC;
    }
    
    return _mainVC;
}

- (UINavigationController *)settingsVC {
    if (!_settingsVC) {
        _settingsVC = [[UINavigationController alloc] initWithRootViewController:[[SMSettingsViewController alloc] init]];
        [self.mainVC addChildViewController:_settingsVC];
        [self.mainVC.view addSubview:_settingsVC.view];
        
        self.poped = YES;
        _settingsVC.view.width = WIDTH_NAV_L;
        _settingsVC.view.top = [AppDelegate navigationHeight];
        _settingsVC.view.height = self.window.height - _homeVC.view.top;
        _settingsVC.view.alpha = kAlpha;
        
        [self.childVCs addObject:_settingsVC];
    }
    return _settingsVC;
}

- (UINavigationController *)homeVC {
    if (!_homeVC) {
        _homeVC = [[UINavigationController alloc] initWithRootViewController:[[SMHomeViewController alloc] init]];
        [self.mainVC addChildViewController:_homeVC];
        [self.mainVC.view addSubview:_homeVC.view];
        
        _homeVC.view.right = 0;
        _homeVC.view.width = WIDTH_NAV_L;
        _homeVC.view.top = [AppDelegate navigationHeight];
        _homeVC.view.height = self.window.height - _homeVC.view.top;
        _homeVC.view.alpha = kAlpha;

        [self.childVCs addObject:_homeVC];
    }
    return _homeVC;
}

- (UINavigationController *)accessoriesVC {
    if (!_accessoriesVC) {
        _accessoriesVC = [[UINavigationController alloc] initWithRootViewController:[[SMAccessoryListViewController alloc] init]];
        [self.mainVC addChildViewController:_accessoriesVC];
        [self.mainVC.view addSubview:_accessoriesVC.view];

        _accessoriesVC.view.right = 0;
        _accessoriesVC.view.width = WIDTH_NAV_L;
        _accessoriesVC.view.top = [AppDelegate navigationHeight];
        _accessoriesVC.view.height = self.window.height - _homeVC.view.top;
        _accessoriesVC.view.alpha = kAlpha;
        
        [self.childVCs addObject:_accessoriesVC];
    }
    return _accessoriesVC;
}

#pragma mark - Actions

- (void)button1Pressed:(UIButton *)sender {
    if (!sender.isSelected) {
        [self resetChildVCsWithCurrentVC:self.settingsVC];
        sender.selected = YES;
    }
}

- (void)button2Pressed:(UIButton *)sender {
    if (!sender.isSelected) {
        [self resetChildVCsWithCurrentVC:self.homeVC];
        sender.selected = YES;
    }
}

- (void)button3Pressed:(UIButton *)sender {
    if (!sender.isSelected) {
        [self resetChildVCsWithCurrentVC:self.accessoriesVC];
        sender.selected = YES;
    }
}

- (void)resetChildVCsWithCurrentVC:(UIViewController *)currentVC {
    [self.mainVC.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = ((UIBarButtonItem *)obj).customView;
        button.selected = NO;
    }];
    [self.childVCs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ((UIViewController *)obj).view.hidden = YES;
    }];
    
    if (self.isPoped) {
        currentVC.view.left = 0;
    } else {
        currentVC.view.right = 0;
    }
    currentVC.view.hidden = NO;
    self.currentVC = currentVC;
}

- (void)animateWithPop {
    [UIView animateWithDuration:kTimeInterval animations:^{
        self.currentVC.view.frame = CGRectMake(0, self.currentVC.view.frame.origin.y, self.currentVC.view.frame.size.width, self.currentVC.view.frame.size.height);
    } completion:^(BOOL finished) {
        self.poped = YES;
    }];
}

- (void)animateWithDismiss {
    [UIView animateWithDuration:kTimeInterval animations:^{
        self.currentVC.view.frame = CGRectMake(-self.currentVC.view.frame.size.width, self.currentVC.view.frame.origin.y, self.currentVC.view.frame.size.width, self.currentVC.view.frame.size.height);
    } completion:^(BOOL finished) {
        self.poped = NO;
    }];
}

- (void)panMenu:(UIPanGestureRecognizer *)pan {
    CGPoint p = [pan translationInView:self.currentVC.view];
    CGPoint v = [pan velocityInView:self.currentVC.view];
    
    CGFloat y = self.currentVC.view.frame.origin.y;
    CGFloat w = self.currentVC.view.frame.size.width;
    CGFloat h = self.currentVC.view.frame.size.height;
    
    if (self.currentVC.view.frame.origin.x + p.x > 0) {
        self.currentVC.view.frame = CGRectMake(0, y, w, h);
    } else if (CGRectGetMaxX(self.currentVC.view.frame) + p.x < 0) {
        self.currentVC.view.frame = CGRectMake(-w, y, w, h);
    } else {
        self.currentVC.view.frame = CGRectMake(self.currentVC.view.frame.origin.x + p.x, y, w, h);
    }
    [pan setTranslation:CGPointMake(0, 0) inView:self.currentVC.view];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (v.x > kVelocity) { // 向右快速滑动
            [self animateWithPop];
        } else if (v.x < -kVelocity) { // 向左快速滑动
            [self animateWithDismiss];
        } else { // 正常拖拽结束
            if (self.currentVC.view.frame.origin.x >= (-w) / 2) {
                [self animateWithPop];
            } else {
                [self animateWithDismiss];
            }
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UISlider"]) {
        return NO;
    }
    
    return YES;
}

@end
