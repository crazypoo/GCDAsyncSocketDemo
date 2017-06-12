//
//  UIButton+SinceTheCustom.m
//  socketDemo
//
//  Created by 紫川秀 on 2017/6/12.
//  Copyright © 2017年 View. All rights reserved.
//

#import "UIButton+SinceTheCustom.h"

@implementation UIButton (SinceTheCustom)

-(UIButton *)initWithText:(NSString *)text andTextColor:(UIColor *)textColor andFont:(CGFloat)font andNSTextAlignment:(NSTextAlignment)textAlignment andBorderColor:(UIColor *)borderColor andBorderWidth:(CGFloat)borderWidth{
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    btn.titleLabel.textAlignment = textAlignment;
    btn.layer.borderColor = borderColor.CGColor;
    btn.layer.borderWidth = borderWidth;
    
    return btn;
}

@end
