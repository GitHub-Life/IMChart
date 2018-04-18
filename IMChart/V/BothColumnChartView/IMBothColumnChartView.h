//
//  IMBothColumnChartView.h
//  IMChartDemo
//
//  Created by 万涛 on 2018/4/18.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IMChartData;

@interface IMBothColumnChartView : UIView

/** 数据 */
@property (nonatomic, strong) NSArray<IMChartData *> *dataArray;
/** 显示数据的字体 */
@property (nonatomic, copy) UIFont *dataFont;
/** 正值颜色 */
@property (nonatomic, copy) UIColor *positiveColor;
/** 负值颜色 */
@property (nonatomic, copy) UIColor *negativeColor;
/** 坐标轴颜色 */
@property (nonatomic, copy) UIColor *coordAxisColor;
/** 图标边距 */
@property (nonatomic, assign) UIEdgeInsets chartEdgeInsets;

/** 是否绘制时间 */
@property (nonatomic, assign) BOOL drawTime;
/** 时间格式化字符串 */
@property (nonatomic, copy) NSString *dateFormat;
/** 时间字体 */
@property (nonatomic, copy) UIFont *timeFont;
/** 描述文字颜色(时间也用此色) */
@property (nonatomic, copy) UIColor *descColor;
/** 描述集合，当此值不为nil或empty时，则绘制描述 */
@property (nonatomic, strong) NSArray<NSString *> *descArray;
/** 显示描述的字体 */
@property (nonatomic, copy) UIFont *descFont;

@end
