//
//  IMChartData.h
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/24.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMPoint : NSObject
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
+ (instancetype)point:(CGFloat)x :(CGFloat)y;
- (CGPoint)cgPoint;
@end

@interface IMChartData : NSObject

/** 用于绘制线的数据集合，数组中有几个元素，就可绘制几条线 */
@property (nonatomic, strong) NSArray<NSNumber *> *lineValues;
/** 用于绘制条形柱状图的值 */
@property (nonatomic, strong) NSNumber *columeValue;
/** 时间戳 */
@property (nonatomic, assign) NSTimeInterval timeStamp;

/** 用于绘制线的坐标集合【由lineValues转换而得】 */
@property (nonatomic, strong) NSArray<IMPoint *> *linePoints;
/** 用于绘制条形柱状图的坐标 两个坐标，第一个值为0，即y为视图高度值【由columeValue转换而得】 */
@property (nonatomic, strong) NSArray<IMPoint *> *columnPoints;

@end
