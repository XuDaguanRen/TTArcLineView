//
//  TTArcLineView.h
//  TTArcLineView
//
//  Created by Maiya on 2019/4/9.
//  Copyright © 2019 Maiya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTArcLineView : UIView

/**  进度条轨道颜色 */
@property(nonatomic, strong) UIColor *progressTrackColor;
/**  内部进度条颜色 */
@property(nonatomic, strong) UIColor *internalArcColor;
/**  外部表盘最大值 */
@property (nonatomic,assign) CGFloat externalArcMaxValue;
/**  表盘当前值 */
@property (nonatomic,assign) CGFloat externalValue;
/**  内部表盘最大值 */
@property (nonatomic,assign) CGFloat internalArcMaxValue;
/**  内部表盘当前值大值 */
@property (nonatomic,assign) CGFloat internalValue;
/** 圆心中间文案  */
@property (nonatomic, strong) NSString *highestValueString;
/**  最高值文字颜色 */
@property(nonatomic, strong) UIColor *highestLColor;
/** 圆心中间文案 */
@property (nonatomic, strong) NSString *myValueString;
/**  我的值文案颜色 */
@property(nonatomic, strong) UIColor *myLColor;

/**
 初始化方法

 @param frame 表盘大小
 @param strokeWidth 进度底部宽度
 @param progressWidth 进度宽度
 @param beginColor 进度开始颜色
 @param endColor 进度结束颜色
 */
- (instancetype)initWithFrame:(CGRect)frame strokeWidth:(CGFloat)strokeWidth progressWidth:(CGFloat)progressWidth beginColor:(UIColor*)beginColor endColor:(UIColor *)endColor;

/**
 表盘动画
 */
- (void)stroke;
@end

NS_ASSUME_NONNULL_END
