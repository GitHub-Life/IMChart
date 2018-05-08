//
//  IMTrendColumnChartView.m
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/26.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMTrendColumnChartView.h"
#import "IMChartDataGroup.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "IMTrendColumnChartPainer.h"
#import "IMChartPoint.h"

@interface IMTrendColumnChartView ()

/** X轴方向 单位宽度 */
@property (nonatomic, assign) CGFloat unitX;

@property (nonatomic, strong) NSArray<IMChartData *> *drawDataArray;

@end

@implementation IMTrendColumnChartView

- (instancetype)init {
    if (self = [super init]) {
        [self initSetting];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self initSetting];
    }
    return self;
}

- (void)initSetting {
    _yReferenceCount = 2;
    _hideYReference = NO;
    _coordAxisColor = [UIColor lightGrayColor];
    _columnColor = [UIColor darkGrayColor];
    _dataGroup = [[IMChartDataGroup alloc] init];
    @weakify(self);
    [RACObserve(self.dataGroup, dataArray) subscribeNext:^(id x) {
        @strongify(self);
        [self draw];
    }];
    [RACObserve(self, drawBeginOffsetX) subscribeNext:^(id x) {
        @strongify(self);
        [self draw];
    }];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    if (!_hideYReference && _yReferenceCount > 1) {
        // 绘制Y轴参考虚线
        CGFloat step = height / (_yReferenceCount - 1);
        CGContextSetLineWidth(context, 0.5);
        CGContextSetStrokeColorWithColor(context, _coordAxisColor.CGColor);
        CGContextBeginPath(context);
        for (int i = 0; i < _yReferenceCount; i++) {
            CGContextMoveToPoint(context, 0, i * step);
            CGContextAddLineToPoint(context, width, i * step);
        }
        CGContextStrokePath(context);
    }
    
    if (_drawDataArray.count == 0) {
        return;
    }
    
    CGContextSetLineWidth(context, _unitX);
    CGContextSetStrokeColorWithColor(context, _columnColor.CGColor);
    [[[IMTrendColumnChartPainer alloc] init] drawWithDataArray:_drawDataArray context:context];
    
}

- (void)draw {
    [self setDatasPosition];
    [self setNeedsDisplay];
}

- (void)setDatasPosition {
    if (_dataGroup.dataArray.count == 0) {
        return;
    }
    
    _unitX = self.frame.size.width / (_dataGroup.dataArray.count * 2 - 1);
    
    NSInteger beginIndex = MAX(_drawBeginOffsetX / (_unitX * 2), 0);
    NSInteger endIndex = MIN((_drawBeginOffsetX + _drawAreaWidth) / (_unitX * 2) + 1, _dataGroup.dataArray.count - 1);
    if (beginIndex > endIndex) {
        beginIndex = 0;
    }
    _drawDataArray = [_dataGroup.dataArray subarrayWithRange:NSMakeRange(beginIndex, endIndex - beginIndex)];
    
    CGFloat maxValue = _drawDataArray.firstObject.columnValue.doubleValue;
    CGFloat minValue = _drawDataArray.firstObject.columnValue.doubleValue;
    for (IMChartData *data in _drawDataArray) {
        if (data.columnValue.doubleValue > maxValue) {
            maxValue = data.columnValue.doubleValue;
        }
        if (data.columnValue.doubleValue < minValue) {
            minValue = data.columnValue.doubleValue;
        }
    }
    
    CGFloat diff = (maxValue - minValue) * 0.05;
    maxValue += diff;
    minValue -= diff;
    
    CGFloat minY = 0;
    CGFloat maxY = self.frame.size.height;
    CGFloat unitValue = (maxValue - minValue) / (maxY - minY);
    
    for (int i = 0; i < _drawDataArray.count; i++) {
        IMChartData *data = _drawDataArray[i];
        CGFloat xPosition = (beginIndex + i) * _unitX * 2;
        IMChartPoint *columnPoint = [IMChartPoint point:xPosition :maxY - (unitValue > 0 ? ((data.columnValue.doubleValue - minValue) / unitValue) : 0)];
        columnPoint.dataYzeroPoint = [IMChartPoint point:xPosition :maxY];
        data.columnPoint = columnPoint;
    }
}

@end
