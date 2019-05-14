//
//  UIViewController+Show.h
//  SMAPP
//
//  Created by Jason on 15/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Show)

- (void)showError:(NSError *)error;

- (void)showText:(NSString *)text;
- (void)showText:(NSString *)text duration:(CGFloat)duration;
- (void)showText:(NSString *)text autoHide:(BOOL)autoHide;
- (void)hideText;

- (BOOL)isShowingText;

- (void)showIndicator;
- (void)hideIndicator;

@end

NS_ASSUME_NONNULL_END
