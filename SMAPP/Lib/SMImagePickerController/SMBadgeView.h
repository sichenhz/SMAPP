//
//  SMBadgeView.h
//  SMAPP
//
//  Created by Sichen on 28/7/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SMBadgeViewAlignment) {
    SMBadgeViewAlignmentLeft = 0,
    SMBadgeViewAlignmentCenter,
    SMBadgeViewAlignmentRight
};

typedef NS_ENUM(NSInteger, SMBadgeViewType) {
    SMBadgeViewTypeDefault = 0,
    SMBadgeViewTypeWhiteBorder
};

@interface SMBadgeView : UIView

/**
 *  A rectangle defining the frame of the SMBadgeView object. The size components of this rectangle are ignored.
 */
- (instancetype)initWithFrame:(CGRect)frame alignment:(SMBadgeViewAlignment)alignment type:(SMBadgeViewType)type NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

#if TARGET_INTERFACE_BUILDER
@property (nonatomic, assign) IBInspectable NSInteger alignment;
@property (nonatomic, assign) IBInspectable NSInteger type;
#else
@property (nonatomic, assign, readonly) SMBadgeViewAlignment alignment;
@property (nonatomic, assign, readonly) SMBadgeViewType type;
#endif

@property (nonatomic, assign) IBInspectable NSInteger number;
@property (nonatomic, strong) IBInspectable UIColor *backgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *textColor;

@end
