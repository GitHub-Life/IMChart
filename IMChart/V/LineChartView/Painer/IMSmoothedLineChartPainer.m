//
//  IMSmoothedLineChartPainer.m
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/24.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMSmoothedLineChartPainer.h"
#import "IMChartData.h"
#import "IMChartPoint.h"

@implementation IMSmoothedLineChartPainer

- (void)drawWithDataArray:(NSArray<IMChartData *> *)dataArray context:(CGContextRef)context lineColors:(NSArray<UIColor *> *)lineColors lineShowStates:(NSArray<NSNumber *> *)lineShowStates {
    NSInteger lineQty = MIN(MIN(dataArray[0].linePoints.count, lineColors.count), lineShowStates.count);
    NSMutableArray<NSArray<IMChartPoint *> *> *points = [NSMutableArray array];
    for (int i = 0; i < lineQty; i++) {
        NSMutableArray<IMChartPoint *> *subPoints = [NSMutableArray array];
        for (IMChartData *data in dataArray) {
            [subPoints addObject:data.linePoints[i]];
        }
        [points addObject:subPoints];
    }
    
    for (int i = 0; i < lineQty; i++) {
        if (![lineShowStates[i] boolValue]) {
            continue;
        }
        UIBezierPath *curvedPath = [self curvedPathWithPoints:points[i]];
        [lineColors[i] setStroke];
        [curvedPath stroke];
        if (_gradientFill) {
            [curvedPath addLineToPoint:CGPointMake(dataArray.lastObject.linePoints[i].cgPoint.x, _drawSize.height)];
            [curvedPath addLineToPoint:CGPointMake(dataArray.firstObject.linePoints[i].cgPoint.x, _drawSize.height)];
            [curvedPath closePath];
            
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGFloat locations[] = {0.f, 1.f};
            NSArray *colors = @[(__bridge id)[lineColors[i] colorWithAlphaComponent:0.1f].CGColor, (__bridge id)[lineColors[i] colorWithAlphaComponent:0.f].CGColor];
            CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
            CGContextSaveGState(context);
            CGContextAddPath(context, curvedPath.CGPath);
            CGContextClip(context);
            CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, _drawSize.height), kCGGradientDrawsBeforeStartLocation);
            CGGradientRelease(gradient);
            CGColorSpaceRelease(colorSpace);
        }
    }
}

- (UIBezierPath *)curvedPathWithPoints:(NSArray<IMChartPoint *> *)points {
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
