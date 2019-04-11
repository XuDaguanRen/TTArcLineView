//
//  TTArcLineView.m
//  TTArcLineView
//
//  Created by Maiya on 2019/4/9.
//  Copyright © 2019 Maiya. All rights reserved.
//

#import "TTArcLineView.h"

#define kAnimationDuration 1.3f

@interface TTArcLineView () {
    
    CAShapeLayer *backGroundLayer;      //背景图层
    CAShapeLayer *internalLayer;        //内部圆图层
    CAShapeLayer *frontFillLayer;       //用来填充的图层
    CAShapeLayer *internalFillLayer;    //内部进度y图层

}
/** 外部渐变背景图层  */
@property(nonatomic, strong) CAGradientLayer *gradientLayer;
/**  内部渐变背景图层 */
@property(nonatomic, strong) CAGradientLayer *internalGradient;
/**  进度条渐变开始颜色 */
@property(nonatomic, strong) UIColor *beginColor;
/**  进度条渐变结束颜色 */
@property(nonatomic, strong) UIColor *endColor;
/**  中心点 */
@property (nonatomic) CGPoint curPoint;
/**  圆盘开始角度 */
@property(nonatomic, assign) CGFloat startAngle;
/**  圆盘结束角度 */
@property(nonatomic, assign) CGFloat endAngle;
/**  圆盘总共弧度弧度 */
@property(nonatomic, assign) CGFloat arcAngle;
/**  半径 */
@property(nonatomic, assign) CGFloat arcRadius;
/**  刻度半径 */
@property(nonatomic, assign) CGFloat scaleRadius;
/**  线宽 */
@property(nonatomic, assign) CGFloat progressWidth;
/**  边宽 */
@property(nonatomic, assign) CGFloat strokeWidth;
/**  中间最高文案Label */
@property (nonatomic, strong) UILabel *highestAmountL;
/**  中间我的文案Label */
@property (nonatomic, strong) UILabel *myAmountL;

@end

@implementation TTArcLineView

- (instancetype)initWithFrame:(CGRect)frame strokeWidth:(CGFloat)strokeWidth progressWidth:(CGFloat)progressWidth beginColor:(UIColor*)beginColor endColor:(UIColor *)endColor {
    self = [super initWithFrame:frame];
    if (self) {
        _beginColor = beginColor;
        _endColor = endColor;
        //保存弧线宽度,开始角度，结束角度
        self.startAngle = -M_PI_4*5;
        self.endAngle = M_PI_4;
        self.arcAngle = self.endAngle-self.startAngle;
        self.arcRadius = (CGRectGetWidth(self.bounds) - strokeWidth - progressWidth)/2.f;
        self.scaleRadius = self.arcRadius - strokeWidth - 10;
        self.strokeWidth = strokeWidth;
        self.progressWidth = progressWidth;
        [self setupUI];
    }
    return self;
}

- (void)dealloc {
    [self.layer removeAllAnimations];
    self.gradientLayer = nil;
    self.internalGradient = nil;
    backGroundLayer = nil;
    internalLayer = nil;
    frontFillLayer = nil;
    internalFillLayer = nil;
}

/// 我的值文案颜色
- (void)setMyLColor:(UIColor *)myLColor {
    _myLColor = myLColor;
    self.myAmountL.textColor = _myLColor;
}

/// 我的值文案
- (void)setMyValueString:(NSString *)myValueString {
    _myValueString = myValueString;
    self.myAmountL.text = _myValueString;
}

/// 最高值文字颜色
- (void)setHighestLColor:(UIColor *)highestLColor {
    _highestLColor = highestLColor;
    self.highestAmountL.textColor = _highestLColor;
}

/// 最高值文案
- (void)setHighestValueString:(NSString *)highestValueString {
    _highestValueString = highestValueString;
    self.highestAmountL.text = _highestValueString;
}

/// 内部表盘当前需要显示的刻度值
- (void)setInternalValue:(CGFloat)internalValue {
    _internalValue = internalValue;
    CGFloat value = _internalValue/_internalArcMaxValue;
    UIBezierPath *internalPath = [UIBezierPath bezierPathWithArcCenter:self.curPoint radius: self.arcRadius/2 + 15  - 4 startAngle: self.startAngle endAngle: (3*M_PI_2)*value + self.startAngle clockwise:YES];
    internalFillLayer.path = internalPath.CGPath;
}

/// 内部表盘最大值
- (void)setInternalArcMaxValue:(CGFloat)internalArcMaxValue {
    _internalArcMaxValue = internalArcMaxValue;
}

/// 外部表盘当前需要显示的刻度值
- (void)setExternalValue:(CGFloat)externalValue {
    _externalValue = externalValue;
    CGFloat value = _externalValue/_externalArcMaxValue;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.curPoint radius:self.arcRadius startAngle: self.startAngle endAngle: (3*M_PI_2)*value + self.startAngle clockwise:YES]; // 背景和进度开始要保
    frontFillLayer.path = path.CGPath;
}

/// 外部表盘最大值 根据值等分刻度表
- (void)setExternalArcMaxValue:(CGFloat)externalArcMaxValue {
    _externalArcMaxValue = externalArcMaxValue;
    [self drawScaleValueWithDivide:10 scaleMaxValue:_externalArcMaxValue];
}

/// 内部进度线条
- (void)setInternalProgressColor:(UIColor *)internalProgressColor {
    _internalProgressColor = internalProgressColor;
    [self internalDrawGradientLayer];
}

/// 内部进度条颜色
- (void)setInternalArcColor:(UIColor *)internalArcColor {
    _internalArcColor = internalArcColor;
    internalLayer.fillColor = _internalArcColor.CGColor;
}

/// 进度底部背景颜色
- (void)setProgressTrackColor:(UIColor *)progressTrackColor {
    _progressTrackColor = progressTrackColor;
    backGroundLayer.strokeColor = progressTrackColor.CGColor;
}

#pragma mark -  动画效果
- (void)stroke {
    
    //画图动画
    self.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration  = kAnimationDuration;
    animation.fromValue = @0.0f;
    animation.toValue   = @1.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    [frontFillLayer addAnimation:animation forKey:@"circleAnimation"];
    [internalFillLayer addAnimation:animation forKey:@"circleAnimation"];
}

#pragma mark - 圆弧等分
- (void)drawScaleValueWithDivide:(NSInteger)divide scaleMaxValue:(CGFloat)scaleMaxValue {
    CGFloat textAngel = self.arcAngle/divide;
    
    if (divide==0) {
        return;
    }
    for (NSUInteger i = 0; i <= divide; i++) {
        CGPoint point = [self calculateTextPositonWithArcCenter:self.curPoint Angle:-(self.endAngle-textAngel*i)];
        NSString *tickText = [NSString stringWithFormat:@"%0.0f",(divide - i)*scaleMaxValue/divide];
        //默认label的大小23 * 14
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(point.x - 17, point.y - 8, 35, 14)];
        text.text = tickText;
        text.font = [UIFont systemFontOfSize:11.f];
        text.textColor = [UIColor redColor];
        text.textAlignment = NSTextAlignmentCenter;
        [self addSubview:text];
    }
}

#pragma mark -  计算label的坐标
- (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center Angle:(CGFloat)angel {
    CGFloat x = self.scaleRadius * cosf(angel);
    CGFloat y = self.scaleRadius * sinf(angel);
    return CGPointMake(center.x + x, center.y - y);
}

#pragma mark -
- (void)internalDrawGradientLayer {
    
    self.internalGradient.colors = @[(__bridge id)_internalProgressColor.CGColor,
                                     (__bridge id)_internalProgressColor.CGColor];
    //    self.internalGradient.locations  = @[@(0.0), @(0.2), @(0.8)];
    self.internalGradient.startPoint = CGPointMake(0, 0.5);
    self.internalGradient.endPoint = CGPointMake(1, 0.5);
    [self.layer insertSublayer:self.internalGradient atIndex:0];
    self.internalGradient.mask = internalFillLayer;
}

#pragma mark - 圆环内部View
- (void)internalArcLineView {
    
    //创建背景图层
    internalLayer = [CAShapeLayer layer];
    internalLayer.fillColor = UIColor.whiteColor.CGColor;
    internalLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    internalLayer.lineCap = kCALineCapRound;
    internalLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:internalLayer];
    
    UIBezierPath *ovalpath = [UIBezierPath bezierPathWithArcCenter:self.curPoint radius: self.arcRadius/2 + 15 startAngle: 0.0 endAngle: M_PI*2 clockwise:YES];
    internalLayer.path = ovalpath.CGPath;
    
    //创建填充图层
    internalFillLayer = [CAShapeLayer layer];
    internalFillLayer.fillColor = [UIColor clearColor].CGColor;
    internalFillLayer.strokeColor = [UIColor whiteColor].CGColor;
    internalFillLayer.lineWidth = 3;
    internalFillLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    internalFillLayer.lineCap = kCALineCapRound; //线终点
    internalFillLayer.lineJoin = kCALineJoinRound; // 线拐角
    [self.layer addSublayer:internalFillLayer];
}

#pragma mark -  外部圆形视图
- (void)setupArcLineViewUI {
    
    //设置圆弧的圆心
    self.curPoint = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
    //创建背景图层
    backGroundLayer = [CAShapeLayer layer];
    backGroundLayer.lineWidth = self.strokeWidth;
    backGroundLayer.fillColor = [UIColor clearColor].CGColor;
    backGroundLayer.frame = self.bounds;
    backGroundLayer.lineCap = kCALineCapRound;
    backGroundLayer.lineJoin = kCALineJoinRound;
    /**
     设置圆弧进度百分比
     ArcCenter: 原点
     radius: 半径
     startAngle: 开始角度
     endAngle: 结束角度
     clockwise: 是否顺时针方向
     */
    UIBezierPath *pathBag = [UIBezierPath bezierPathWithArcCenter:self.curPoint radius:self.arcRadius startAngle: self.startAngle endAngle: self.endAngle clockwise:YES]; // 背景和进度开始要保
    backGroundLayer.path = pathBag.CGPath;
    
    //创建填充图层
    frontFillLayer = [CAShapeLayer layer];
    frontFillLayer.lineWidth = self.progressWidth;
    frontFillLayer.fillColor = [UIColor clearColor].CGColor;
    frontFillLayer.strokeColor = [UIColor whiteColor].CGColor;
    frontFillLayer.frame = self.bounds;
    frontFillLayer.lineCap = kCALineCapRound; //线终点
    frontFillLayer.lineJoin = kCALineJoinRound; // 线拐角
    
    self.gradientLayer.colors = @[(__bridge id)_beginColor.CGColor,
                             (__bridge id)_endColor.CGColor];
    //    gradientLayer.locations  = @[@(0.0), @(0.2), @(0.8)];
    self.gradientLayer.startPoint = CGPointMake(0, 0.5);
    self.gradientLayer.endPoint = CGPointMake(1, 0.5);
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
    self.gradientLayer.mask = frontFillLayer;
    [self.layer addSublayer:backGroundLayer];
    [self.layer insertSublayer:backGroundLayer atIndex:0];
}

#pragma mark -  布局UI
- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    [self setupArcLineViewUI];
    [self internalArcLineView];
    
    self.highestAmountL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.arcRadius, 30)];
    self.highestAmountL.center = CGPointMake(self.curPoint.x, self.curPoint.y-20);
    self.highestAmountL.textAlignment = NSTextAlignmentCenter;
    self.highestAmountL.font = [UIFont systemFontOfSize:14];
    self.highestAmountL.text = [NSString stringWithFormat:@"最高:100万"];
    self.highestAmountL.textColor = [UIColor redColor];
    //        self.highestAmountL.backgroundColor = UIColor.redColor;
    [self addSubview:self.highestAmountL];
    
    self.myAmountL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.arcRadius, 30)];
    self.myAmountL.center = CGPointMake(self.highestAmountL.center.x, self.curPoint.y+20);
    self.myAmountL.text = @"我的: 22.11万";
    self.myAmountL.font = [UIFont systemFontOfSize:14];
    self.myAmountL.textColor = [UIColor redColor];
    self.myAmountL.textAlignment = NSTextAlignmentCenter;
    //        self.myAmountL.backgroundColor = UIColor.blueColor;
    [self addSubview:self.myAmountL];
}


- (CAGradientLayer *)internalGradient {
    if (!_internalGradient) {
        _internalGradient = [CAGradientLayer layer];
        _internalGradient.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    }
    return _internalGradient;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    }
    return _gradientLayer;
}

@end
