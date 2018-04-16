//
//  IMChartTimeLineView.h
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/26.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMChartTimeLineView : UIView

/** 本视图宽度，默认为屏幕宽度，要设置的话，请在设置 itemTitles 之前设置此值 */
@property (nonatomic, assign) CGFloat width;

/** 所有数据的时间戳集合 */
@property (nonatomic, strong) NSArray<NSNumber *> *timeStamps;
/** 需要显示的时间戳数量 【默认显示四个】*/
@property (nonatomic, assign) IBInspectable NSInteger showCount;
/** 显示的时间格式化字符串 */
@property (nonatomic, strong) IBInspectable NSString *dateFormat;
/** 字体 */
@property (nonatomic, strong) UIFont *font;
/** 字体颜色 */
@property (nonatomic, strong) IBInspectable UIColor *textColor;
/** 参考线颜色 */
@property (nonatomic, strong) IBInspectable UIColor *referenceColor;

@end
