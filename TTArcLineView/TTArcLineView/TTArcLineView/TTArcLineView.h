//
//  TTArcLineView.h
//  TTArcLineView
//
//  Created by Maiya on 2019/4/9.
//  Copyright © 2019 Maiya. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 表盘枚举
typedef NS_ENUM(NSInteger, TTArcLineType) {
    TTArcLineType__IsRound = 0,   /// 正圆
    TTArcLineType_Semicircle = 1,   ///半圆
};

NS_ASSUME_NONNULL_BEGIN

//弧度转角度
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
//角度转弧度
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface TTArcLineView : UIView
/**  当前线类型  画的圆环是虚线还是实线的 默认实线 */
@property (nonatomic,assign) TTArcLineType arcLineType;

/**  表盘最大值 */
@property (nonatomic,assign) CGFloat externalArcMaxValue;
/**  表盘当前值 */
@property (nonatomic,assign) CGFloat externalValue;
/**  内部表盘最大值 */
@property (nonatomic,assign) CGFloat internalArcMaxValue;
/**  内部表盘当前值大值 */
@property (nonatomic,assign) CGFloat internalValue;
/**  进度值0-1.0之间 */
@property (nonatomic,assign) CGFloat progressValue;

/**  进度条颜色 */
@property(nonatomic, strong) UIColor *internalArcColor;
/**  进度条轨道颜色 */
@property(nonatomic, strong) UIColor *progressTrackColor;
/** 圆心中间文案  */
@property (nonatomic, strong) UILabel *highestAmountL;
/** 圆心中间文案 */
@property (nonatomic, strong) UILabel *myAmountL;

/**
 初始化方法

 @param frame 表盘大小
 @param strokeWidth 进度底部宽度
 @param progressWidth 进度宽度
 @param beginColor 进度开始颜色
 @param endColor 进度结束颜色
 */
- (instancetype)initWithFrame:(CGRect)frame strokeWidth:(CGFloat)strokeWidth progressWidth:(CGFloat)progressWidth beginColor:(UIColor*)beginColor endColor:(UIColor *)endColor;

- (void)stroke;
@end

NS_ASSUME_NONNULL_END
