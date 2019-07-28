//
//  SMToastView.h
//  SMAPP
//
//  Created by Sichen on 15/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMToastView : UIView

+ (void)showInView:(nonnull UIView *)view text:(nonnull NSString *)text duration:(CGFloat)duration autoHide:(BOOL)autoHide;
+ (void)hideInView:(nonnull UIView *)view;
+ (BOOL)isShowingInView:(nonnull UIView *)view;

@end

NS_ASSUME_NONNULL_END
