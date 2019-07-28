//
//  UIViewController+Show.m
//  SMAPP
//
//  Created by Sichen on 15/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "UIViewController+Show.h"
#import <objc/runtime.h>
#import "SMToastView.h"
#import "SMActivityIndicatorView.h"
#import "Masonry.h"

@implementation UIViewController (Show)

- (void)showError:(NSError *)error {
    [self showText:error.userInfo[@"NSLocalizedDescription"]];
}

- (void)showText:(NSString *)text {
    [self showText:text autoHide:YES];
}

- (void)showText:(NSString *)text duration:(CGFloat)duration {
    [SMToastView showInView:[UIApplication sharedApplication].keyWindow text:text duration:duration autoHide:YES];
}

- (void)showText:(NSString *)text autoHide:(BOOL)autoHide {
    [SMToastView showInView:[UIApplication sharedApplication].keyWindow text:text duration:1.5 autoHide:autoHide];
}

- (void)hideText {
    [SMToastView hideInView:[UIApplication sharedApplication].keyWindow];
}

- (BOOL)isShowingText {
    return [SMToastView isShowingInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showIndicator {
    SMActivityIndicatorView *indicator = objc_getAssociatedObject(self, @selector(showIndicator));
    if (indicator == nil) {
        indicator = [[SMActivityIndicatorView alloc] initWithStyle:SMActivityIndicatorViewStyleDefault];
        [self.view addSubview:indicator];
        [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
        }];
        objc_setAssociatedObject(self, @selector(showIndicator), indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [indicator startAnimating];
}

- (void)hideIndicator {
    SMActivityIndicatorView *indicator = objc_getAssociatedObject(self, @selector(showIndicator));
    [indicator stopAnimating];
}

@end
