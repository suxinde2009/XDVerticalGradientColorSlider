//
//  XDVerticalColorSlider.m
//  XDVerticalColorSilder
//
//  Created by suxinde on 2017/7/27.
//  Copyright © 2017年 com.skyprayer.toy. All rights reserved.
//

#import "XDVerticalGradientColorSlider.h"
#import <Masonry/Masonry.h>

static float kXDVerticalGradientColorSliderBorderPadding = 2.0f;
static float kXDVerticalGradientColorSliderWidth = 12.0f;
static float kXDVerticalGradientColorThumbViewCicleSize = 48.0f;
static float kXDVerticalGradientColorThumbViewBubbleWidth = 58.0f;
static float kXDVerticalGradientColorSliderCornerRadius = 6.0f;
static float kXDVerticalGradientColorBarCornerRadius = 4.0f;
static float kXDVerticalGradientColorThumbBubblePadding = 8.0f;

@interface XDVerticalGradientColorBar : UIView

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

- (UIColor *)colorOfPointInGradientColorBar:(CGPoint)point;

@end

@implementation XDVerticalGradientColorBar

UIColor *XDVerticalGradientColorSliderGetFromIntegers(float r, float g, float b) {
    return [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f];
}

#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame
                   withColors:(NSArray *)colors {
    if (self = [super initWithFrame:frame]) {
        [self privateInitWithColors:colors];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame  {
    return [self initWithFrame:frame withColors:nil];
}

// for when coming out of a nib
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self privateInitWithColors:nil];
    }
    return self;
}

- (void)privateInitWithColors:(NSArray *)colors {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = kXDVerticalGradientColorBarCornerRadius;
    self.backgroundColor = [UIColor clearColor];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bounds;
    self.gradientLayer.cornerRadius = kXDVerticalGradientColorBarCornerRadius;
    self.gradientLayer.masksToBounds = YES;
    
    //self.gradientLayer.colors = self.colors;
    
    NSMutableArray *gradientColors = [[NSMutableArray alloc] initWithCapacity:0];
    if (colors && colors.count > 0) {
        for(UIColor *color in colors) {
            [gradientColors addObject:((id)color.CGColor)];
        }
    } else {
        NSArray *colors = @[
                            (id)XDVerticalGradientColorSliderGetFromIntegers(255.0f, 255.0f, 255.0f).CGColor,
                            (id)XDVerticalGradientColorSliderGetFromIntegers(7.0f, 0.0f, 0.0f).CGColor,
                            (id)XDVerticalGradientColorSliderGetFromIntegers(252.0f, 45.0f, 1.0f).CGColor,
                            (id)XDVerticalGradientColorSliderGetFromIntegers(228.0f, 255.0f, 1.0f).CGColor,
                            (id)XDVerticalGradientColorSliderGetFromIntegers(1.0f, 255.0f, 55.0f).CGColor,
                            (id)XDVerticalGradientColorSliderGetFromIntegers(2.0f, 255.0f, 163.0f).CGColor,
                            (id)XDVerticalGradientColorSliderGetFromIntegers(1.0f, 87.0f, 254.0f).CGColor,
                            (id)XDVerticalGradientColorSliderGetFromIntegers(235.0f, 7.0f, 214.0f).CGColor,
                            ];
        [gradientColors addObjectsFromArray:colors];
    }
    //  创建渐变色数组，需要转换为CGColor颜色
    self.gradientLayer.colors = gradientColors;
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    
    //[self.layer addSublayer:self.gradientLayer];
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
}


#pragma mark -

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
}

/**
 校正坐标，用于处理手指拖动到滑竿区域外时，计算用于生成选中颜色的坐标点

 @param point 手指触屏的点
 @return 校正后的坐标点
 */
- (CGPoint)convertPointInGradientColorBarCoordinateSystem:(CGPoint)point {
    float x = self.bounds.size.width/2.0f;
    float y = point.y;
    if (y < 0) {
        y = 0;
    } else if (y > self.bounds.size.height) {
        y = self.bounds.size.height;
    }else {
        y = point.y;
    }
    return CGPointMake(x, y);
}


/**
 通过坐标点获取对应颜色

 @param point 坐标点
 @return 坐标点对应的颜色
 */
- (UIColor *)colorOfPointInGradientColorBar:(CGPoint)point {
    CGPoint convertedPoint = [self convertPointInGradientColorBarCoordinateSystem:point];
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, -convertedPoint.x, -convertedPoint.y);
    [self.layer renderInContext:context];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    //NSLog(@"pixel: %d %d %d %d", pixel[0], pixel[1], pixel[2], pixel[3]);
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0
                                     green:pixel[1]/255.0
                                      blue:pixel[2]/255.0
                                     alpha:pixel[3]/255.0];
    return color;
}

@end

@interface XDVerticalGradientColorSliderThumbView : UIView {
@private
    UIImageView *_bubbleImageView;
    UIView *_colorDisplayView;
}
- (void)setThumbColor:(UIColor *)color;
@end

@implementation XDVerticalGradientColorSliderThumbView

- (void)setThumbColor:(UIColor *)color {
    color ? _colorDisplayView.backgroundColor = color : NULL;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    _bubbleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _bubbleImageView.image = [UIImage imageNamed:@"XDVerticalGradientColorSlider.bundle/ic_gradient__color_slider_bubble"];
    
    _colorDisplayView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_colorDisplayView];
    [self addSubview:_bubbleImageView];
    
    __weak typeof(self) weakSelf = self;
    [_bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    _colorDisplayView.layer.cornerRadius = (kXDVerticalGradientColorThumbViewCicleSize/2.0f);
    _colorDisplayView.clipsToBounds = YES;
    [_colorDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf);
        make.height.mas_equalTo(@(kXDVerticalGradientColorThumbViewCicleSize));
        make.width.mas_equalTo(@(kXDVerticalGradientColorThumbViewCicleSize));
        make.left.mas_equalTo(weakSelf);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

@end


@interface XDVerticalGradientColorSlider ()

@property (nonatomic, strong) XDVerticalGradientColorBar *colorBar;
@property (nonatomic, strong) UIView *colorBarContainerView;
@property (nonatomic, strong) XDVerticalGradientColorSliderThumbView *thumbView;

@end

@implementation XDVerticalGradientColorSlider

+ (instancetype)createGradientColorSliderWithColors:(NSArray *)colors {
    XDVerticalGradientColorSlider *slider = [[XDVerticalGradientColorSlider alloc] initWithFrame:CGRectZero withColors:colors];
    return slider;
}

- (instancetype)initWithFrame:(CGRect)frame
                   withColors:(NSArray *)colors {
    if (self = [super initWithFrame:frame]) {
        [self privateInitWithColors:colors];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame  {
    return [self initWithFrame:frame withColors:nil];
}

// for when coming out of a nib
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self privateInitWithColors:nil];
    }
    return self;
}

- (void)privateInitWithColors:(NSArray *)colors {
    self.backgroundColor = [UIColor clearColor];
    
    self.colorBar = [[XDVerticalGradientColorBar alloc] initWithFrame:CGRectZero
                                                           withColors:colors];
    self.colorBarContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.colorBarContainerView.backgroundColor = [UIColor whiteColor];
    [self.colorBarContainerView addSubview:self.colorBar];
    self.colorBarContainerView.layer.cornerRadius = kXDVerticalGradientColorSliderCornerRadius;
    self.colorBarContainerView.clipsToBounds = YES;
    float thumbViewXOffset = (kXDVerticalGradientColorThumbViewBubbleWidth)-((self.bounds.size.width/2.0f)-(kXDVerticalGradientColorSliderWidth/2.0f)+kXDVerticalGradientColorThumbBubblePadding);
    
    self.thumbView = [[XDVerticalGradientColorSliderThumbView alloc] initWithFrame:CGRectMake(-thumbViewXOffset,
                                                                                              0,
                                                                                              kXDVerticalGradientColorThumbViewBubbleWidth,
                                                                                              kXDVerticalGradientColorThumbViewCicleSize)];
    [self addSubview:self.colorBarContainerView];
    [self addSubview:self.thumbView];
    self.thumbView.alpha = 0.0f;
    
    __weak typeof(self) weakSelf = self;
    [self.colorBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kXDVerticalGradientColorSliderBorderPadding,
                                                kXDVerticalGradientColorSliderBorderPadding,
                                                kXDVerticalGradientColorSliderBorderPadding,
                                                kXDVerticalGradientColorSliderBorderPadding));
        make.center.mas_equalTo(weakSelf.colorBarContainerView);
    }];
    
    [self.colorBarContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(weakSelf);
        make.width.mas_equalTo(@(kXDVerticalGradientColorSliderWidth));
        make.center.mas_equalTo(weakSelf);
    }];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.colorBar.layer.cornerRadius = (self.layer.cornerRadius-kXDVerticalGradientColorSliderBorderPadding);
}

#pragma mark - 

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:touches];
    self.thumbView.alpha = 1.0f;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:touches];
    [UIView animateWithDuration:0.5 animations:^{
        self.thumbView.alpha = 0.0f;
    }];
}

- (float)convertPointYToValidInGradientColorSlider:(float)pointY {
    float y = pointY;
    if (y < kXDVerticalGradientColorSliderBorderPadding) {
        y = kXDVerticalGradientColorSliderBorderPadding;
    } else if (y > (self.bounds.size.height-(2*kXDVerticalGradientColorSliderBorderPadding))) {
        y = self.bounds.size.height-(2*kXDVerticalGradientColorSliderBorderPadding);
    }else {
        y = pointY;
    }
    return y;
}

- (void)handleTouches:(NSSet *)touches {
    CGPoint point = [((UITouch *)[touches anyObject]) locationInView:self];
    float calibratedPointY = [self convertPointYToValidInGradientColorSlider:point.y];
    CGPoint calibratedPoint = CGPointMake(self.center.x, calibratedPointY);
    CGPoint pointInGradientColorBar = [self convertPoint:calibratedPoint toView:self.colorBar];
    
    _selectedColor = [self.colorBar colorOfPointInGradientColorBar:pointInGradientColorBar];
    self.thumbView.center = CGPointMake(self.thumbView.center.x, calibratedPointY);
    [self.thumbView setThumbColor:_selectedColor];
    
    if (self.valueChangedHandler) {
        __weak typeof(self) weakSelf = self;
        self.valueChangedHandler(weakSelf.selectedColor);
    }

}


@end
