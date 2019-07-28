//
//  UITextView+Placeholder.h
//  SMAPP
//
//  Created by Sichen on 15/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (Placeholder)

@property (nonatomic, copy)IBInspectable NSString *placeholder;
@property (nonatomic, strong)IBInspectable UIColor *placeholderColor;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, assign)IBInspectable NSInteger maxLength;

@property (nonatomic, copy) void (^textDidChange)(NSString *text);

@end

NS_ASSUME_NONNULL_END
