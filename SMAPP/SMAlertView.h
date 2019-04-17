//
//  SMAlertView.h
//  SMAPP
//
//  Created by Jason on 16/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SMAlertActionStyle) {
    SMAlertActionStyleDefault = 0,
    SMAlertActionStyleCancel,
    SMAlertActionStyleConfirm
};

typedef NS_ENUM(NSInteger, SMAlertViewStyle) {
    SMAlertViewStyleAlert = 0,
    SMAlertViewStyleActionSheet
};

NS_ASSUME_NONNULL_BEGIN

@interface SMAlertButton : UIButton

@end

@interface SMAlertAction : NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(SMAlertActionStyle)style handler:(void (^ __nullable)(SMAlertAction *action))handler;
+ (instancetype)actionWithTitle:(nullable NSString *)title style:(SMAlertActionStyle)style selected:(BOOL)selected handler:(void (^ __nullable)(SMAlertAction *action))handler;

@property (nonatomic, copy, readonly, nullable) NSString *title;
@property (nonatomic, assign, readonly) SMAlertActionStyle style;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end

@interface SMAlertView : UIView

+ (instancetype)alertViewWithTitle:(nullable NSString *)title message:(nullable NSString *)message style:(SMAlertViewStyle)style;
+ (instancetype)alertViewWithAttributedTitle:(nullable NSAttributedString *)title message:(nullable NSString *)message style:(SMAlertViewStyle)style;
+ (instancetype)alertViewWithTitle:(nullable NSString *)title attributedMessage:(nullable NSAttributedString *)message style:(SMAlertViewStyle)style;
+ (instancetype)alertViewWithAttributedTitle:(nullable NSAttributedString *)title attributedMessage:(nullable NSAttributedString *)message style:(SMAlertViewStyle)style;

- (void)addAction:(SMAlertAction *)action;
- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;

@property (nonatomic, strong, readonly) NSArray<SMAlertAction *> *actions;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSAttributedString *attrTitle;
@property (nonatomic, copy, nullable) NSString *message;
@property (nonatomic, copy, nullable) NSAttributedString *attrMessage;
@property (nonatomic, readonly, nullable) NSArray<UITextField *> *textFields;

@property (nonatomic, readonly) SMAlertViewStyle style;

- (void)show;

@end

NS_ASSUME_NONNULL_END
