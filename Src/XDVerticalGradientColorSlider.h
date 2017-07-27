//
//  XDVerticalColorSlider.h
//  XDVerticalColorSilder
//
//  Created by suxinde on 2017/7/27.
//  Copyright © 2017年 com.skyprayer.toy. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^XDVerticalGradientColorSliderValueChangedHandler)(UIColor *color);

@interface XDVerticalGradientColorSlider : UIView

@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, copy) XDVerticalGradientColorSliderValueChangedHandler valueChangedHandler;

+ (instancetype)createGradientColorSliderWithColors:(NSArray *)colors;

@end

