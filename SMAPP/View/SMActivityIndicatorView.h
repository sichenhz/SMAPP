//
//  SMActivityIndicatorView.h
//  SMAPP
//
//  Created by Sichen on 15/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SMActivityIndicatorViewStyle) {
    SMActivityIndicatorViewStyleDefault = 0,
    SMActivityIndicatorViewStyleCircle,
    SMActivityIndicatorViewStyleCircleLarge
};

NS_ASSUME_NONNULL_BEGIN

@interface SMActivityIndicatorView : UIView

- (instancetype)initWithStyle:(SMActivityIndicatorViewStyle)style NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

#if TARGET_INTERFACE_BUILDER
@property (nonatomic) IBInspectable NSInteger style;
#else
@property (nonatomic) SMActivityIndicatorViewStyle style;
#endif

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

@end

NS_ASSUME_NONNULL_END
