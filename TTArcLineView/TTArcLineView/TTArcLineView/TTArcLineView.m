//
//  TTArcLineView.m
//  TTArcLineView
//
//  Created by Maiya on 2019/4/9.
//  Copyright © 2019 Maiya. All rights reserved.
//

#import "TTArcLineView.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)//角都转弧度

#define ANGLE 20 // 没份20度 共220度
#define kAnimationDuration 1.0f

@interface TTArcLineView () {
    
    CAShapeLayer *backGroundLayer;      //背景图层
    CAShapeLayer *backGroundLayer1;
    CAShapeLayer *frontFillLayer;       //用来填充的图层
    UIBezierPath *backGroundBezierPath; //背景贝赛尔曲线
    UIBezierPath *frontFillBezierPath;  //用来填充的贝赛尔曲线
    CAGradientLayer *gradientLayer;     //渐变背景图层
}
/**  中心点 */
@property (nonatomic) CGPoint curPoint;

@end

@implementation TTArcLineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupArcLineViewUI];
    }
    return self;
}

- (void)dealloc {
    [self.layer removeAllAnimations];
}

- (void)setColorsArray:(NSArray *)colorsArray {
    _colorsArray = colorsArray;
    gradientLayer.colors = colorsArray;
}

//设置进度颜色
- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    frontFillLayer.strokeColor = progressColor.CGColor;
}

/// 设置背景颜色
- (void)setProgressTrackColor:(UIColor *)progressTrackColor {
    _progressTrackColor = progressTrackColor;
    backGroundLayer.strokeColor = progressTrackColor.CGColor;
    UIBezierPath *pathBag = [UIBezierPath bezierPathWithArcCenter:self.curPoint radius:(CGRectGetWidth(self.bounds)-self.progressStrokeWidth - 10)/2.f startAngle: M_PI_4*3 endAngle: M_PI_4 clockwise:YES]; // 背景和进度开始要保
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
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.curPoint radius:(CGRectGetWidth(self.bounds)-self.progressStrokeWidth - 10)/2.f startAngle: M_PI_4*3 endAngle: (3*M_PI_2)*progressValue + M_PI_4 * 3 clockwise:YES]; // 背景和进度开始要保
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
}

/// 绘制渐变图层
- (void)drawGradientLayer {
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                             (__bridge id)[UIColor greenColor].CGColor,
                             (__bridge id)[UIColor yellowColor].CGColor,
                             (__bridge id)[UIColor blueColor].CGColor];
//    gradientLayer.locations  = @[@(0.0), @(0.2), @(0.8)];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

#pragma mark - 圆环内部View
- (void)internalArcLineView {
    CGFloat width = self.frame.size.width - self.progressStrokeWidth - 50 - 80;
    UIBezierPath *ovalpath = [UIBezierPath bezierPathWithArcCenter:self.curPoint radius: width/2 startAngle: 0.0 endAngle: M_PI*2 clockwise:YES];

    //创建背景图层
    backGroundLayer1 = [CAShapeLayer layer];
    backGroundLayer1.fillColor = UIColor.redColor.CGColor;
    backGroundLayer1.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    backGroundLayer1.lineCap = kCALineCapRound;
    backGroundLayer1.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:backGroundLayer1];
    backGroundLayer1.path = ovalpath.CGPath;

}

- (void)setupArcLineViewUI {
    self.backgroundColor = [UIColor whiteColor];
    //设置圆弧的圆心
    self.curPoint = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
    //创建背景图层
    backGroundLayer = [CAShapeLayer layer];
    backGroundLayer.fillColor = nil;
    backGroundLayer.frame = self.bounds;
    backGroundLayer.lineCap = kCALineCapRound;
    backGroundLayer.lineJoin = kCALineJoinRound;
    
    //创建填充图层
    frontFillLayer = [CAShapeLayer layer];
    frontFillLayer.fillColor = nil;
    frontFillLayer.frame = self.bounds;
    frontFillLayer.lineCap = kCALineCapRound; //线终点
    frontFillLayer.lineJoin = kCALineJoinRound; // 线拐角
    [self drawGradientLayer]; // 渐变
    [self.layer addSublayer:backGroundLayer];
    gradientLayer.mask = frontFillLayer;
    [self.layer insertSublayer:backGroundLayer atIndex:0];
    
    //创建文字说明
    if (!self.labelArray.count) {
        for (int i = 0; i < self.titleArray.count; i++) {
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
    
    [self internalArcLineView];
}

//创建文字说明 label
- (void)creatLabel:(NSString *)title withScore:(CGFloat)index{

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 23, 15)];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.textColor = [UIColor blackColor];
    [self addSubview:label];
    CGFloat endAngle = index*ANGLE-200+10;
    label.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(endAngle)+M_PI_2);//label 旋转
    CGSize size = self.frame.size;
    CGFloat  centerY = size.width/2 - (size.width/2-30)*sin(DEGREES_TO_RADIANS(index*ANGLE-10));
    CGFloat centerX = size.width/2 - (size.width/2-30)*cos(DEGREES_TO_RADIANS(index*ANGLE-10));
    label.center = CGPointMake(centerX, centerY);
    [self.labelArray addObject:label];

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
        _titleArray = [NSMutableArray arrayWithCapacity:0];
        [_titleArray addObject:@"0"];
        [_titleArray addObject:@"一般"];
        [_titleArray addObject:@"60"];
        [_titleArray addObject:@"中等"];
        [_titleArray addObject:@"70"];
        [_titleArray addObject:@"良好"];
        [_titleArray addObject:@"80"];
        [_titleArray addObject:@"优秀"];
        [_titleArray addObject:@"90"];
        [_titleArray addObject:@"极好"];
        [_titleArray addObject:@"100"];
    }
    return _titleArray;
}
@end
