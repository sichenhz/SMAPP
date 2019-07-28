//
//  UIImage+SMHelper.h
//  SMAPP
//
//  Created by Sichen on 28/7/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SMHelper)

+ (CGSize)sc_resizeForSend:(CGSize)size;

- (UIImage *)sc_crop:(CGRect)rect scale:(CGFloat)scale;

- (UIImage *)sc_fixOrientation;

@end
