//
//  ViewController.m
//  XDVerticalGradientColorSlider
//
//  Created by SuXinDe on 2017/7/27.
//  Copyright © 2017年 SkyPrayer Studio. All rights reserved.
//

#import "ViewController.h"
#import "XDVerticalGradientColorSlider.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    XDVerticalGradientColorSlider *colorSlider = [XDVerticalGradientColorSlider createGradientColorSliderWithColors:nil];
    colorSlider.frame = CGRectMake(180, 100, 40, 213);
    [self.view addSubview:colorSlider];
    
    //__weak typeof(self) weakSelf  = self;
    [colorSlider setValueChangedHandler:^(UIColor *color) {
//        weakSelf.view.backgroundColor = color;
        NSLog(@"%@", color);
    }];
    
}

@end
