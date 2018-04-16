//
//  IMChartData.m
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/24.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMChartData.h"

@implementation IMPoint

+ (instancetype)point:(CGFloat)x :(CGFloat)y {
    IMPoint *point = [[IMPoint alloc] init];
    point.x = x;
    point.y = y;
    return point;
}

- (CGPoint)cgPoint {
    return CGPointMake(_x, _y);
}

@end

@implementation IMChartData

@end
