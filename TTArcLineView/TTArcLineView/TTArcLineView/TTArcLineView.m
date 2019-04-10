//
//  TTArcLineView.m
//  TTArcLineView
//
//  Created by Maiya on 2019/4/9.
//  Copyright © 2019 Maiya. All rights reserved.
//

#import "TTArcLineView.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)//角都转弧度

#define ANGLE 25.6 // 没份25度 共252度
#define kAnimationDuration 1.0f

@interface TTArcLineView () {
    
    CAShapeLayer *backGroundLayer;      //背景图层
    CAShapeLayer *internalLayer;        //内部圆图层
    CAShapeLayer *frontFillLayer;       //用来填充的图层
    CAShapeLayer *internalFillLayer;    //内部进度y图层
    CAGradientLayer *gradientLayer;     //渐变背景图层
    CAGradientLayer *internalGradient;     //渐变背景图层
}
/**  中心点 */
@property (nonatomic) CGPoint curPoint;

@end

@implementation TTArcLineView

- (instancetype)initWithFrame:(CGRect)frame beginColor:(UIColor*)beginColor endColor:(UIColor *)endColor; {
    self = [super initWithFrame:frame];
    if (self) {
        _beginColor = beginColor;
        _endColor = endColor;
        
        [self setupUI];
    }
    return self;
}

- (void)dealloc {
    [self.layer removeAllAnimations];
}

- (void)setInternalArcColor:(UIColor *)internalArcColor {
    _internalArcColor = internalArcColor;
    internalLayer.fillColor = _internalArcColor.CGColor;
}

/// 设置背景颜色
- (void)setProgressTrackColor:(UIColor *)progressTrackColor {
    _progressTrackColor = progressTrackColor;
    backGroundLayer.strokeColor = progressTrackColor.CGColor;
    UIBezierPath *pathBag = [UIBezierPath bezierPathWithArcCenter:self.curPoint radius:(CGRectGetWidth(self.bounds)-self.progressStrokeWidth - 15)/2.f startAngle: M_PI_4*3 endAngle: M_PI_4 clockwise:YES]; // 背景和进度开始要保
    backGroundLayer.path = pathBag.CGPath;
}

- (void)setProgressValue:(CGFloat)progressValue {
    _progressValue = progressValue;
    /**
     设置圆弧进度百分比
     ArcCenter: 原点
     radius: 半径
     startAngle: 开始角度
     endAngle: 结束角度
     clockwise: 是否顺时针方向
     */
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.curPoint radius:(CGRectGetWidth(self.bounds)-self.progressStrokeWidth - 15)/2.f startAngle: M_PI_4*3 endAngle: (3*M_PI_2)*progressValue + M_PI_4 * 3 clockwise:YES]; // 背景和进度开始要保
    frontFillLayer.path = path.CGPath;
    
}

//// 设置背景宽度和进度宽度
- (void)setProgressStrokeWidth:(CGFloat)progressStrokeWidth backstrokWidth:(CGFloat)backWidth {
    _progressStrokeWidth = progressStrokeWidth;
    frontFillLayer.lineWidth = progressStrokeWidth;
    backGroundLayer.lineWidth = backWidth;
}

/// 动画效果
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

/// 绘制渐变图层
- (void)drawGradientLayer {
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(__bridge id)_beginColor.CGColor,
                             (__bridge id)_endColor.CGColor];
//    gradientLayer.locations  = @[@(0.0), @(0.2), @(0.8)];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

//创建文字说明 label
- (void)creatLabel:(NSString *)title withScore:(CGFloat)index {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.textColor = [UIColor blackColor];
    [self addSubview:label];
    CGFloat endAngle = index*ANGLE-240+10;
    
    label.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(endAngle)+M_PI_2);//label 旋转
    CGSize size = self.frame.size;
    CGFloat centerY = size.width/2 - (size.width/2-30) * sin(DEGREES_TO_RADIANS(index*ANGLE-40));
    CGFloat centerX = size.width/2 - (size.width/2-30) * cos(DEGREES_TO_RADIANS(index*ANGLE-40));
    label.center = CGPointMake(centerX, centerY);
    [self.labelArray addObject:label];
    
}

#pragma mark - 圆环内部View
- (void)internalArcLineView {

    CGFloat width = (self.frame.size.width - self.progressStrokeWidth - 15)/2.f;
    //创建背景图层
    internalLayer = [CAShapeLayer layer];
    internalLayer.fillColor = UIColor.redColor.CGColor;
    internalLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    internalLayer.lineCap = kCALineCapRound;
    internalLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:internalLayer];
    
    UIBezierPath *ovalpath = [UIBezierPath bezierPathWithArcCenter:self.curPoint radius: width/2 startAngle: 0.0 endAngle: M_PI*2 clockwise:YES];
    internalLayer.path = ovalpath.CGPath;
    
    //创建填充图层
    internalFillLayer = [CAShapeLayer layer];
    internalFillLayer.fillColor = [UIColor clearColor].CGColor;
    internalFillLayer.strokeColor = [UIColor redColor].CGColor;
    internalFillLayer.lineWidth = 3;
    internalFillLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    internalFillLayer.lineCap = kCALineCapRound; //线终点
    internalFillLayer.lineJoin = kCALineJoinRound; // 线拐角
    [self.layer addSublayer:internalFillLayer];
    UIBezierPath *internalPath = [UIBezierPath bezierPathWithArcCenter:self.curPoint radius: width/2 - 4 startAngle: M_PI_4*3 endAngle: M_PI_4 clockwise:YES];
    
    internalFillLayer.path = internalPath.CGPath;
    
    internalGradient = [CAGradientLayer layer];
    internalGradient.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    internalGradient.colors = @[(__bridge id)_beginColor.CGColor,
                             (__bridge id)_endColor.CGColor];
    //    gradientLayer.locations  = @[@(0.0), @(0.2), @(0.8)];
    internalGradient.startPoint = CGPointMake(0, 0.5);
    internalGradient.endPoint = CGPointMake(1, 0.5);
    [self.layer insertSublayer:internalGradient atIndex:0];
    internalGradient.mask = internalFillLayer;
    
}

- (void)setupArcLineViewUI {
    self.backgroundColor = [UIColor whiteColor];
    //设置圆弧的圆心
    self.curPoint = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
    //创建背景图层
    backGroundLayer = [CAShapeLayer layer];
    backGroundLayer.fillColor = [UIColor clearColor].CGColor;
    backGroundLayer.frame = self.bounds;
    backGroundLayer.lineCap = kCALineCapRound;
    backGroundLayer.lineJoin = kCALineJoinRound;
    
    //创建填充图层
    frontFillLayer = [CAShapeLayer layer];
    frontFillLayer.fillColor = [UIColor clearColor].CGColor;
    frontFillLayer.strokeColor = [UIColor whiteColor].CGColor;
    frontFillLayer.frame = self.bounds;
    frontFillLayer.lineCap = kCALineCapRound; //线终点
    frontFillLayer.lineJoin = kCALineJoinRound; // 线拐角
    [self drawGradientLayer]; // 渐变
    [self.layer addSublayer:backGroundLayer];
    gradientLayer.mask = frontFillLayer;
    [self.layer insertSublayer:backGroundLayer atIndex:0];
}

#pragma mark -  布局UI
- (void)setupUI {
    [self setupArcLineViewUI];
    [self internalArcLineView];
    //创建文字说明
    if (!self.labelArray.count) {
        for (int i = 0; i < 11; i++) {
            [self creatLabel:self.titleArray[i] withScore:i];
        }
        
        self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.scoreLabel.center = CGPointMake(self.curPoint.x, self.curPoint.y-30);
        self.scoreLabel.textAlignment = NSTextAlignmentCenter;
        self.scoreLabel.font = [UIFont systemFontOfSize:55];
        self.scoreLabel.text = [NSString stringWithFormat:@"%.0f", _starScore*100];
        self.scoreLabel.textColor = [UIColor redColor];
        [self addSubview:self.scoreLabel];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        label.center = CGPointMake(self.scoreLabel.center.x, self.curPoint.y+10);
        label.text = @"我的是多少22.11万";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
}

#pragma mark - lazy loading
- (NSMutableArray *)labelArray {
    if (!_labelArray) {
        _labelArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _labelArray;
}

- (NSMutableArray *)titleArray { //分值对应等级
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
        [_titleArray addObject:@"0"];
        [_titleArray addObject:@"10"];
        [_titleArray addObject:@"20"];
        [_titleArray addObject:@"30"];
        [_titleArray addObject:@"40"];
        [_titleArray addObject:@"50"];
        [_titleArray addObject:@"60"];
        [_titleArray addObject:@"70"];
        [_titleArray addObject:@"80"];
        [_titleArray addObject:@"90"];
        [_titleArray addObject:@"100"];
    }
    return _titleArray;
}
@end
