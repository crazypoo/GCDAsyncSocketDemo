//
//  UITextField+SinceTheCustom.m
//  socketDemo
//
//  Created by 紫川秀 on 2017/6/12.
//  Copyright © 2017年 View. All rights reserved.
//

#import "UITextField+SinceTheCustom.h"

@implementation UITextField (SinceTheCustom)

-(UITextField *)initWithText:(NSString *)text andPlaceholder:(NSString *)placeholder andTextColor:(UIColor *)textColor andFont:(CGFloat)font andNSTextAlignment:(NSTextAlignment)textAlignment andBorderColor:(UIColor *)borderColor andBorderWidth:(CGFloat)borderWidth{
    
    UITextField *textField = [[UITextField alloc]init];
    textField.text = text;
    textField.placeholder = placeholder;
    textField.textColor = textColor;
    textField.font = [UIFont systemFontOfSize:font];
    textField.textAlignment = textAlignment;
    textField.layer.borderColor = borderColor.CGColor;
    textField.layer.borderWidth = borderWidth;
    
    return textField;
}

@end
