//
//  IMLineChartView.h
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/24.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IMChartDataGroup;
@class IMChartData;

@interface IMLineChartView : UIView

/** 需要显示的Y轴参考线数量 默认为5 */
@property (nonatomic, assign) int yReferenceCount;
/** 隐藏Y轴参考线 */
@property (nonatomic, assign) BOOL hideYReference;
/** 坐标轴颜色 */
@property (nonatomic, strong) UIColor *coordAxisColor;
/** 线宽 */
@property (nonatomic, assign) CGFloat lineWidth;
/** Y轴是否从零开始 */
@property (nonatomic, assign) BOOL yStartZero;
/** 是否画贝塞尔曲线 还是 折线 */
@property (nonatomic, assign) BOOL smoothed;
/** 是否渐变填充 */
@property (nonatomic, assign) BOOL gradientFill;
/** 是否动画绘制 */
@property (nonatomic, assign) BOOL drawAnimation;

/** 显示的线的状态集合 0:不显示，非零显示; 数组为nil或empty则不显示 */
@property (nonatomic, strong) NSArray<NSNumber *> *lineShowStates;
/** 线的颜色集合; 数组为nil或empty则不显示 */
@property (nonatomic, strong) NSArray<UIColor *> *lineColors;

@property (nonatomic, strong) IMChartDataGroup *dataGroup;

@property (nonatomic, strong) NSArray<NSNumber *> *timeStamps;

/** 开始绘制的X轴偏移量(设置此值开始重绘) */
@property (nonatomic, assign) CGFloat drawBeginOffsetX;
/** 绘制区域宽度 */
@property (nonatomic, assign) CGFloat drawAreaWidth;

- (IMChartData *)dataWithPoint:(CGPoint)point;

/** 又捏合手势的中心点X坐标 计算X方向的偏移量，准备以此偏移量重绘 */
- (CGFloat)offsetXWithPinCenterX:(CGFloat)pinCenterX;

@end
