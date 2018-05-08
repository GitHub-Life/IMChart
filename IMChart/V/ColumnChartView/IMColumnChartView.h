//
//  IMColumnChartView.h
//  NiuYan
//
//  Created by 万涛 on 2018/5/2.
//  Copyright © 2018年 niuyan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IMChartData;

@interface IMColumnChartView : UIView

/** 数据 */
@property (nonatomic, strong) NSArray<IMChartData *> *dataArray;
/** 数据文本(当此值为nil或count<dataArray.count时,则显示dataArray中的columnValue) */
@property (nonatomic, strong) NSArray<NSString *> *dataTextArray;
/** 显示数据的字体 */
@property (nonatomic, copy) UIFont *dataFont;
/** 显示数据保留的小数位数 */
@property (nonatomic, assign) IBInspectable int fractionalDigits;
/** 柱状图颜色，当元素数量<dataArray.count时,颜色循环取用 */
@property (nonatomic, strong) NSArray<UIColor *> *columnColorArray;
/** 坐标轴颜色 */
@property (nonatomic, copy) IBInspectable UIColor *coordAxisColor;
/** 图表边距 */
@property (nonatomic, assign) UIEdgeInsets chartEdgeInsets;

/** 是否绘制时间 */
@property (nonatomic, assign) IBInspectable BOOL drawTime;
/** 时间格式化字符串 */
@property (nonatomic, copy) IBInspectable NSString *dateFormat;
/** 时间字体 */
@property (nonatomic, copy) UIFont *timeFont;
/** 描述文字颜色(时间也用此色) */
@property (nonatomic, copy) IBInspectable UIColor *descColor;
/** 描述集合，当此值不为nil或empty且元素数量>=dataArray.count时，则绘制描述 */
@property (nonatomic, strong) NSArray<NSString *> *descArray;
/** 显示描述的字体 */
@property (nonatomic, copy) UIFont *descFont;
/** 当描述字体超过对应显示范围自动缩小 */
@property (nonatomic, assign) IBInspectable BOOL descAdjustsFontSizeToFitWidth;

@end
