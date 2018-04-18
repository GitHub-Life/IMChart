//
//  IMChartPoint.h
//  IMChartDemo
//
//  Created by 万涛 on 2018/4/18.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMChartPoint : NSObject

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

+ (instancetype)point:(CGPoint)cgPoint;

+ (instancetype)point:(CGFloat)x :(CGFloat)y;

- (CGPoint)cgPoint;

/** 数据的零点坐标值 */
@property (nonatomic, strong) IMChartPoint *dataYzeroPoint;

@property (nonatomic, assign) NSInteger index;

@end
