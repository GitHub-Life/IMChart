//
//  IMSmoothedLineChartPainer.m
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/24.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMSmoothedLineChartPainer.h"
#import "IMChartData.h"

@implementation IMSmoothedLineChartPainer

- (void)drawWithDataArray:(NSArray<IMChartData *> *)dataArray context:(CGContextRef)context lineColors:(NSArray<UIColor *> *)lineColors lineShowStates:(NSArray<NSNumber *> *)lineShowStates {
    NSInteger lineQty = MIN(MIN(dataArray[0].linePoints.count, lineColors.count), lineShowStates.count);
    NSMutableArray<NSArray<IMPoint *> *> *points = [NSMutableArray array];
    for (int i = 0; i < lineQty; i++) {
        NSMutableArray<IMPoint *> *subPoints = [NSMutableArray array];
        for (IMChartData *data in dataArray) {
            [subPoints addObject:data.linePoints[i]];
        }
        [points addObject:subPoints];
    }
    
    CGContextBeginPath(context);
    for (int i = 0; i < lineQty; i++) {
        if (![lineShowStates[i] boolValue]) {
            continue;
        }
        UIBezierPath *curvedPath = [self curvedPathWithPoints:points[i]];
        CGContextSetStrokeColorWithColor(context, lineColors[i].CGColor);
        CGContextAddPath(context, curvedPath.CGPath);
        CGContextDrawPath(context, kCGPathStroke);
    }
    CGContextStrokePath(context);
}

- (UIBezierPath *)curvedPathWithPoints:(NSArray<IMPoint *> *)points {
    UIBezierPath *curvedPath = [[UIBezierPath alloc] init];
    [curvedPath moveToPoint:points[0].cgPoint];
    if (points.count == 2) {
        [curvedPath addLineToPoint:points[1].cgPoint];
        return curvedPath;
    }
    CGPoint p1 = points[0].cgPoint;
    for (int i = 0; i < points.count; i++) {
        CGPoint p2 = points[i].cgPoint;
        CGPoint pointMid = CGPointMake((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
        [curvedPath addCurveToPoint:p2 controlPoint1:CGPointMake(pointMid.x, p1.y) controlPoint2:CGPointMake(pointMid.x, p2.y)];
        p1 = p2;
    }
    return curvedPath;
}

@end
