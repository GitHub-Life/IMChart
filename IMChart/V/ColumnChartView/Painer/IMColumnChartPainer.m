//
//  IMColumnChartPainer.m
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/26.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMColumnChartPainer.h"
#import "IMChartData.h"
#import "IMChartPoint.h"

@implementation IMColumnChartPainer

- (void)drawWithDataArray:(NSArray<IMChartData *> *)dataArray context:(CGContextRef)context {
    CGContextBeginPath(context);
    for (IMChartData *data in dataArray) {
        CGPoint zeroPoint = data.columnPoint.dataYzeroPoint.cgPoint;
        CGPoint valuePoint = data.columnPoint.cgPoint;
        CGContextMoveToPoint(context, zeroPoint.x, zeroPoint.y);
        CGContextAddLineToPoint(context, valuePoint.x, valuePoint.y);
    }
    CGContextStrokePath(context);
}

@end
