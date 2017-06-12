//
//  UILabel+SinceTheCustom.m
//  socketDemo
//
//  Created by 紫川秀 on 2017/6/12.
//  Copyright © 2017年 View. All rights reserved.
//

#import "UILabel+SinceTheCustom.h"

@implementation UILabel (SinceTheCustom)

-(UILabel *)initWithText:(NSString *)text andTextColor:(UIColor *)textColor andFont:(CGFloat)font andNSTextAlignment:(NSTextAlignment)textAlignment andBorderColor:(UIColor *)borderColor andBorderWidth:(CGFloat)borderWidth{

    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:font];
    label.textAlignment = textAlignment;
    label.layer.borderColor = borderColor.CGColor;
    [label.layer setBorderWidth:borderWidth];
    
    return label;
}

@end
