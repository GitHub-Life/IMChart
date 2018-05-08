//
//  IMTrendColumnChartView.h
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/26.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IMChartDataGroup;

@interface IMTrendColumnChartView : UIView

/** 需要显示的Y轴参考线数量 默认为2 */
@property (nonatomic, assign) int yReferenceCount;
/** 隐藏Y轴参考线 */
@property (nonatomic, assign) BOOL hideYReference;
/** 坐标轴颜色 */
@property (nonatomic, strong) UIColor *coordAxisColor;
/** 条形颜色 */
@property (nonatomic, strong) UIColor *columnColor;

@property (nonatomic, strong) IMChartDataGroup *dataGroup;

/** 开始绘制的X轴偏移量(设置此值开始重绘) */
@property (nonatomic, assign) CGFloat drawBeginOffsetX;
/** 绘制区域宽度 */
@property (nonatomic, assign) CGFloat drawAreaWidth;

@end
