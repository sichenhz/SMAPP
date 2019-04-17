//
//  SMAlertView.m
//  SMAPP
//
//  Created by Jason on 16/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMAlertView.h"
#import "Const.h"
#import "SMButton.h"

@interface SMAlertAction()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, assign, readwrite) SMAlertActionStyle style;
@property (nonatomic, copy) void (^handler)(SMAlertAction *action);

@end

@implementation SMAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(SMAlertActionStyle)style handler:(void (^)(SMAlertAction *action))handler {
    return [self actionWithTitle:title style:style selected:NO handler:handler];
}

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(SMAlertActionStyle)style selected:(BOOL)selected handler:(void (^ __nullable)(SMAlertAction *action))handler {
    SMAlertAction *alertAction = [[SMAlertAction alloc] init];
    alertAction.title = title;
    alertAction.style = style;
    alertAction.selected = selected;
    alertAction.handler = handler;
    return alertAction;
}

@end

@interface SMAlertView()

@property (nonatomic, readwrite) NSArray<SMAlertAction *> *actions;
@property (nonatomic, readwrite) NSArray<UITextField *> *textFields;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *messageLabel;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic) BOOL isShowing;
@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, readwrite) SMAlertViewStyle style;
@property (nonatomic) CGFloat buttonHeight;

@end

@implementation SMAlertView
{
    CGFloat _buttonHeight;
}

#pragma mark - Public Method

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message style:(SMAlertViewStyle)style {
    SMAlertView *alertView = [self alertViewWithStyle:style];
    alertView.title = title;
    alertView.message = message;
    return alertView;
}

+ (instancetype)alertViewWithAttributedTitle:(NSAttributedString *)title message:(NSString *)message style:(SMAlertViewStyle)style {
    SMAlertView *alertView = [self alertViewWithStyle:style];
    alertView.attrTitle = title;
    alertView.message = message;
    return alertView;
}

+ (instancetype)alertViewWithTitle:(NSString *)title attributedMessage:(NSAttributedString *)message style:(SMAlertViewStyle)style {
    SMAlertView *alertView = [self alertViewWithStyle:style];
    alertView.title = title;
    alertView.attrMessage = message;
    return alertView;
}

+ (instancetype)alertViewWithAttributedTitle:(NSAttributedString *)title attributedMessage:(NSAttributedString *)message style:(SMAlertViewStyle)style {
    SMAlertView *alertView = [self alertViewWithStyle:style];
    alertView.attrTitle = title;
    alertView.attrMessage = message;
    return alertView;
}

- (void)addAction:(SMAlertAction *)action {
    NSMutableArray *arrM = [NSMutableArray arrayWithArray:self.actions];
    [arrM addObject:action];
    self.actions = [arrM copy];
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler {
    
    NSAssert(self.style == SMAlertViewStyleAlert, @"Text fields can only be added to an alert controller of style SMAlertViewStyleAlert'");
    
    NSMutableArray *arrM = [NSMutableArray arrayWithArray:self.textFields];
    UITextField *textField = [[UITextField alloc] init];
    textField.font = FONT_BODY;
    [arrM addObject:textField];
    self.textFields = [arrM copy];
    
    configurationHandler(textField);
}

- (void)show {
    if (self.isShowing) {
        return;
    }
    self.isShowing = YES;
    
    [self layoutAlertView];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.frame = window.bounds;
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    [backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTap:)]];
    [window addSubview:backgroundView];
    _backgroundView = backgroundView;
    [window addSubview:self];
    
    if (self.style == SMAlertViewStyleAlert) {
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(1.15, 1.15);
        [UIView animateWithDuration:0.2 animations:^{
            backgroundView.alpha = 0.4;
            self.alpha = 1;
            self.transform = CGAffineTransformMakeScale(1, 1);
        }];
        
        if (self.textFields.count) {
            UITextField *textField = self.textFields.firstObject;
            [textField becomeFirstResponder];
            
            [UIView animateWithDuration:0.2 animations:^{
                self.transform = CGAffineTransformMakeTranslation(0, -335/2);
            }];
            
        }

    } else {
        self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height);
        [UIView animateWithDuration:0.2 animations:^{
            backgroundView.alpha = 0.4;
            self.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = title;
        self.titleLabel.text = title;
    }
}

- (void)setAttrTitle:(NSAttributedString *)attrTitle {
    if (_attrTitle != attrTitle) {
        _attrTitle = attrTitle;
        self.titleLabel.attributedText = attrTitle;
    }
}

- (void)setMessage:(NSString *)message {
    if (_message != message) {
        _message = message;
        self.messageLabel.text = message;
    }
}

- (void)setAttrMessage:(NSAttributedString *)attrMessage {
    if (_attrMessage != attrMessage) {
        _attrMessage = attrMessage;
        self.messageLabel.attributedText = attrMessage;
    }
}

#pragma mark - Private Method

+ (instancetype)alertViewWithStyle:(SMAlertViewStyle)style {
    SMAlertView *alertView = [[SMAlertView alloc] init];
    alertView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:237/255.0 alpha:1];
    alertView.style = style;
    if (style == SMAlertViewStyleAlert) {
        alertView.buttonHeight = 44;
        CGFloat width = 270;
        CGFloat x = ([UIScreen mainScreen].bounds.size.width - width) / 2.0;
        alertView.frame = CGRectMake(x, 0, width, 0);
        alertView.layer.cornerRadius = 12;
        alertView.clipsToBounds = YES;
    } else {
        alertView.buttonHeight = 50;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        alertView.frame = CGRectMake(0, 0, width, 0);
    }
    return alertView;
}

- (void)layoutAlertView {
    if (self.style == SMAlertViewStyleAlert) {
        [self layoutAlert];
    } else {
        [self layoutActionSheet];
    }
}

- (void)layoutAlert {
    CGFloat height = 0;
    CGFloat labelWidth = self.frame.size.width - 32;
    if (self.title || self.attrTitle) {
        height += 22;
        CGRect frame = self.titleLabel.frame;
        frame.origin.y = height;
        frame.size.height = [self.titleLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)].height;
        self.titleLabel.frame = frame;
        height += frame.size.height;
    }
    
    if (self.message || self.attrMessage) {
        if (self.title || self.attrTitle) {
            height += 5;
        } else {
            height += 22;
        }
        CGRect frame = self.messageLabel.frame;
        frame.origin.y = height;
        frame.size.height = [self.messageLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)].height;
        self.messageLabel.frame = frame;
        height += frame.size.height;
    }
    
    if ((self.title || self.attrTitle) || (self.message || self.attrMessage)) {
        height += 20;
    }
    
    if (self.textFields.count) {
        for (UITextField *textField in self.textFields) {
            CGFloat width = self.frame.size.width - 32;
            CGFloat x = (self.frame.size.width - width) / 2;
            UIView *container = [[UIView alloc] initWithFrame:CGRectMake(x, height, width, 24)];
            container.backgroundColor = [UIColor whiteColor];
            [self addSubview:container];
            
            textField.frame = CGRectMake(4, 4, container.frame.size.width - 8, 16);
            [container addSubview:textField];
            
            height += container.frame.size.height + 8;
        }
    }
    
    if (self.actions.count) {
        if (self.actions.count == 2) {
            UIView *line = [self layoutLine:self.actions[0] index:0 height:height];
            height += line.frame.size.height;
            SMButton *button = [self createButton:self.actions[0] index:0];
            button.frame = CGRectMake(0, height, self.frame.size.width / 2, self.buttonHeight);
            
            line = [self layoutLine:self.actions[1] index:1 height:height];
            line.frame = CGRectMake(self.frame.size.width / 2, height, 0.5, self.buttonHeight);
            button = [self createButton:self.actions[1] index:1];
            button.frame = CGRectMake(self.frame.size.width / 2, height, self.frame.size.width / 2, self.buttonHeight);
            height += button.frame.size.height;
            
        } else {
            NSInteger indexOfCancel = -1;
            for (SMAlertAction *action in self.actions) {
                NSInteger index = [self.actions indexOfObject:action];
                if (action.style != SMAlertActionStyleCancel) {
                    UIView *line = [self layoutLine:action index:index height:height];
                    height += line.frame.size.height;
                    SMButton *button = [self layoutButton:action index:index height:height];
                    height += button.frame.size.height;
                } else {
                    NSAssert(indexOfCancel == -1, @"SMAlertView can only have one action with a style of SMAlertActionStyleCancel");
                    indexOfCancel = index;
                }
            }
            if (indexOfCancel >= 0) {
                UIView *line = [self layoutLine:self.actions[indexOfCancel] index:indexOfCancel height:height];
                height += line.frame.size.height;
                SMButton *button = [self layoutButton:self.actions[indexOfCancel] index:indexOfCancel height:height];
                height += button.frame.size.height;
            }
        }
    }
    
    CGRect frame = self.frame;
    frame.size.height = height;
    frame.origin.y = ([UIScreen mainScreen].bounds.size.height - height) / 2;
    self.frame = frame;
}

- (void)layoutActionSheet {
    CGFloat height = 0;
    CGFloat labelWidth = self.frame.size.width - 32;
    if (self.title || self.attrTitle) {
        height += 14;
        CGRect frame = self.titleLabel.frame;
        frame.origin.y = height;
        frame.size.height = [self.titleLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)].height;
        self.titleLabel.frame = frame;
        height += frame.size.height;
    }
    
    if (self.message || self.attrMessage) {
        if (self.title || self.attrTitle) {
            height += 2;
        } else {
            height += 14;
        }
        CGRect frame = self.messageLabel.frame;
        frame.origin.y = height;
        frame.size.height = [self.messageLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)].height;
        self.messageLabel.frame = frame;
        height += frame.size.height;
    }
    
    if ((self.title || self.attrTitle) || (self.message || self.attrMessage)) {
        height += 14;
    }
    
    if (self.actions.count) {
        NSInteger indexOfCancel = -1;
        for (SMAlertAction *action in self.actions) {
            NSInteger index = [self.actions indexOfObject:action];
            if (action.style != SMAlertActionStyleCancel) {
                UIView *line = [self layoutLine:action index:index height:height];
                height += line.frame.size.height;
                SMButton *button = [self layoutButton:action index:index height:height];
                height += button.frame.size.height;
            } else {
                NSAssert(indexOfCancel == -1, @"SMAlertView can only have one action with a style of SMAlertActionStyleCancel");
                indexOfCancel = index;
            }
        }
        if (indexOfCancel >= 0) {
            UIView *line = [self layoutLine:self.actions[indexOfCancel] index:indexOfCancel height:height];
            height += line.frame.size.height;
            SMButton *button = [self layoutButton:self.actions[indexOfCancel] index:indexOfCancel height:height];
            height += button.frame.size.height;
        }
    }
    
    CGRect frame = self.frame;
    frame.size.height = height;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - height;
    self.frame = frame;
}

- (UIView *)layoutLine:(SMAlertAction *)action index:(NSInteger)index height:(CGFloat)height {
    UIView *line = [self createLine:action index:index];
    CGRect frame = line.frame;
    frame.origin.y = height;
    line.frame = frame;
    return line;
}

- (SMButton *)layoutButton:(SMAlertAction *)action index:(NSInteger)index height:(CGFloat)height {
    SMButton *button = [self createButton:action index:index];
    button.frame = CGRectMake(0, height, self.frame.size.width, self.buttonHeight);
    return button;
}

- (UIImage *)cornerRadiusBackgroundImage {
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1].CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, 1, 1));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (SMButton *)createButton:(SMAlertAction *)action index:(NSInteger)index {
    SMButton *button;
    if (self.buttons.count > index) {
        button = self.buttons[index];
    } else {
        button = [SMButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[self cornerRadiusBackgroundImage] forState:UIControlStateHighlighted];
        UIImage *image = [UIImage imageNamed:@"choosed"];
        if (action.isSelected) {
            [button setImage:image forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = index + 1000;
        [self addSubview:button];
        [self.buttons addObject:button];
    }
    if (action.style == SMAlertActionStyleConfirm) {
        [button setTitleColor:[UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = FONT_H2_BOLD;
    } else if (action.style == SMAlertActionStyleCancel) {
        [button setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = FONT_H2_BOLD;
    } else {
        [button setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = FONT_H2;
    }
    [button setTitle:action.title forState:UIControlStateNormal];
    return button;
}

- (UIView *)createLine:(SMAlertAction *)action index:(NSInteger)inedx {
    UIView *line;
    if (self.lines.count > inedx) {
        line = self.lines[inedx];
    } else {
        line = [[UIView alloc] init];
        [self addSubview:line];
        [self.lines addObject:line];
    }
    if (self.style == SMAlertViewStyleActionSheet && action.style == SMAlertActionStyleCancel) {
        line.frame = CGRectMake(0, 0, self.frame.size.width, 5);
        line.backgroundColor = [UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1];
    } else {
        line.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
        line.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    }
    return line;
}

- (void)buttonPressed:(SMButton *)sender {
    [self dismiss];
    SMAlertAction *action = self.actions[sender.tag - 1000];
    if (action.handler) {
        action.handler(action);
    }
}

- (void)backgroundViewTap:(id)sender {
    if (self.style == SMAlertViewStyleActionSheet) {
        [self dismiss];
    }
}

- (void)dismiss {
    if (!self.isShowing) {
        return;
    }
    self.isShowing = NO;
    
    if (self.style == SMAlertViewStyleAlert) {
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundView.alpha = 0;
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self.backgroundView removeFromSuperview];
            [self removeFromSuperview];
        }];
    } else {
        self.transform = CGAffineTransformMakeTranslation(0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundView.alpha = 0;
            self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height);
        } completion:^(BOOL finished) {
            [self.backgroundView removeFromSuperview];
            [self removeFromSuperview];
        }];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        CGFloat width = self.frame.size.width - 32;
        CGFloat x = (self.frame.size.width - width) / 2;
        label.frame = CGRectMake(x, 0, width, 0);
        label.font = FONT_H2_BOLD;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [self addSubview:label];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        UILabel *label = [[UILabel alloc] init];
        CGFloat width = self.frame.size.width - 32;
        CGFloat x = (self.frame.size.width - width) / 2;
        label.frame = CGRectMake(x, 0, width, 0);
        label.font = FONT_BODY;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        [self addSubview:label];
        _messageLabel = label;
    }
    return _messageLabel;
}

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (NSMutableArray *)lines {
    if (!_lines) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}

@end
