//
//  IMChartPoint.m
//  IMChartDemo
//
//  Created by 万涛 on 2018/4/18.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMChartPoint.h"

@implementation IMChartPoint

+ (instancetype)point:(CGPoint)cgPoint {
    IMChartPoint *point = [[IMChartPoint alloc] init];
    point.x = cgPoint.x;
    point.y = cgPoint.y;
    return point;
}

+ (instancetype)point:(CGFloat)x :(CGFloat)y {
    IMChartPoint *point = [[IMChartPoint alloc] init];
    point.x = x;
    point.y = y;
    return point;
}

- (CGPoint)cgPoint {
    return CGPointMake(_x, _y);
}

@end
