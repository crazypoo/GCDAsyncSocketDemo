//
//  UILabel+SinceTheCustom.h
//  socketDemo
//
//  Created by 紫川秀 on 2017/6/12.
//  Copyright © 2017年 View. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SinceTheCustom)

-(UILabel *)initWithText:(NSString *)text andTextColor:(UIColor *)textColor andFont:(CGFloat)font andNSTextAlignment:(NSTextAlignment)textAlignment andBorderColor:(UIColor *)borderColor andBorderWidth:(CGFloat)borderWidth;

@end
