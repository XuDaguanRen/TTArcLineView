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
@property (nonatomic,assign) CGFloat maxiMum;
/**  进度值0-1.0之间 */
@property (nonatomic,assign) CGFloat progressValue;
/**  边宽 */
@property(nonatomic, assign) CGFloat progressStrokeWidth;
/**  进度条颜色 */
@property(nonatomic, strong) UIColor *progressColor;
/**  进度条轨道颜色 */
@property(nonatomic, strong) UIColor *progressTrackColor;
/**  进度条渐变开始颜色 */
@property(nonatomic, strong) UIColor *progressBeginColor;
/**  进度条渐变结束颜色 */
@property(nonatomic, strong) UIColor *progressEndColor;
/**  自定义颜色数据数组 */
@property (nonatomic, strong) NSArray *colorsArray;
/**   */
@property (nonatomic, assign) CGFloat starScore;
/**   */
@property (nonatomic, strong) UILabel *scoreLabel;
/**  刻度描述 */
@property (nonatomic, strong) NSMutableArray *labelArray;
/**  默认刻度描述 */
@property (nonatomic, strong) NSMutableArray *titleArray;

/**
 设置背景圆环的宽度，和进度圆环的宽度
 
 @param progressStrokeWidth 进度圆环宽度
 @param backWidth 背景圆环的宽度
 */
- (void)setProgressStrokeWidth:(CGFloat)progressStrokeWidth backstrokWidth:(CGFloat)backWidth;

- (void)stroke;
@end

NS_ASSUME_NONNULL_END
