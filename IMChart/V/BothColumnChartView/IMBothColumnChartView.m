//
//  IMBothColumnChartView.m
//  IMChartDemo
//
//  Created by 万涛 on 2018/4/18.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMBothColumnChartView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIView+Rect.h"
#import "IMChartData.h"
#import "IMChartPoint.h"

@interface IMBothColumnChartView ()
/** x轴方向 单位宽度 */
@property (nonatomic, assign) CGFloat unitX;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation IMBothColumnChartView

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
        [self initBind];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self initView];
        [self initBind];
    }
    return self;
}

- (void)initView {
    _positiveColor = [UIColor redColor];
    _negativeColor = [UIColor greenColor];
    _coordAxisColor = [UIColor lightGrayColor];
    _dataFont = [UIFont systemFontOfSize:10];
    _timeFont = [UIFont systemFontOfSize:10];
    _descFont = [UIFont systemFontOfSize:10];
    _descColor = [UIColor darkGrayColor];
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormat = @"MM-dd";
}

- (void)initBind {
    @weakify(self);
    [RACObserve(self, dataArray) subscribeNext:^(id x) {
        @strongify(self);
        [self draw];
    }];
    [RACObserve(self, dateFormat) subscribeNext:^(id x) {
        @strongify(self);
        self.dateFormatter.dateFormat = x;
    }];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    self.backgroundColor = [UIColor clearColor];
}

- (void)draw {
    [self setDatasPosition];
    [self setNeedsDisplay];
}

- (void)setDatasPosition {
    if (_dataArray.count == 0) {
        return;
    }
    _unitX = (self.width - _chartEdgeInsets.left - _chartEdgeInsets.right) / (_dataArray.count * 2 - 1);
    
    CGFloat maxValue = _dataArray.firstObject.columeValue.doubleValue;
    CGFloat minValue = _dataArray.firstObject.columeValue.doubleValue;
    for (IMChartData *data in _dataArray) {
        CGFloat value = data.columeValue.doubleValue;
        if (value > maxValue) {
            maxValue = value;
        }
        if (value < minValue) {
            minValue = value;
        }
    }
    if (maxValue > -minValue) {
        minValue = -maxValue;
    } else {
        maxValue = -minValue;
    }
    
    CGFloat minY = _chartEdgeInsets.top;
    CGFloat maxY = self.height - _chartEdgeInsets.bottom;
    CGFloat unitY = (maxValue - minValue) / (maxY - minY);
    
    for (int i = 0; i < _dataArray.count; i++) {
        IMChartData *data = _dataArray[i];
        CGFloat num = data.columeValue.doubleValue;
        CGFloat xPosition = _chartEdgeInsets.left + _unitX / 2 + i * (_unitX * 2);
        IMChartPoint *dataPoint = [IMChartPoint point:xPosition :(unitY > 0 ? (maxY - ((num - minValue) / unitY)) : maxY)];
        dataPoint.dataYzeroPoint = [IMChartPoint point:xPosition :(unitY > 0 ? (maxY - (-minValue / unitY)) : maxY)];
        dataPoint.index = i;
        data.columnPoint = dataPoint;
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    if (_dataArray.count == 0) {
        return;
    }
    // 绘制X轴
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, _coordAxisColor.CGColor);
    CGContextMoveToPoint(context, 0, _dataArray.firstObject.columnPoint.dataYzeroPoint.y);
    CGContextAddLineToPoint(context, self.width, _dataArray.firstObject.columnPoint.dataYzeroPoint.y);
    CGContextStrokePath(context);
    
    // 绘制柱状 / 数据 / 描述
    BOOL drawDesc = (_descArray && _descArray.count >= _dataArray.count);
    CGContextSetLineWidth(context, _unitX);
    for (int i = 0; i < _dataArray.count; i++) {
        IMChartData *data = _dataArray[i];
        CGFloat num = data.columeValue.doubleValue;
        BOOL isPositive = num < 0;
        UIColor *color = (isPositive ? _negativeColor : _positiveColor);
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        // 绘制柱状
        CGPoint zeroPoint = data.columnPoint.dataYzeroPoint.cgPoint;
        CGPoint valuePoint = data.columnPoint.cgPoint;
        CGContextMoveToPoint(context, zeroPoint.x, zeroPoint.y);
        CGContextAddLineToPoint(context, valuePoint.x, valuePoint.y);
        CGContextStrokePath(context);
        // 绘制数据
        NSString *text = [NSString stringWithFormat:@"%.2f", num];
        CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName : _dataFont}];
        CGFloat textOffset = (isPositive ? -(textSize.height + 5) : 5);
        CGPoint textAtPoint = CGPointMake(zeroPoint.x - textSize.width / 2, zeroPoint.y + textOffset);
        [text drawAtPoint:textAtPoint withAttributes:@{NSFontAttributeName : _dataFont, NSForegroundColorAttributeName : color}];
        // 绘制描述
        CGFloat descHeight = 0;
        if (drawDesc) {
            CGSize descSize = [_descArray[i] sizeWithAttributes:@{NSFontAttributeName : _descFont}];
            CGPoint descAtPoint = CGPointMake(zeroPoint.x - descSize.width / 2, self.height - descSize.height);
            [_descArray[i] drawAtPoint:descAtPoint withAttributes:@{NSFontAttributeName : _descFont, NSForegroundColorAttributeName : _descColor}];
            descHeight = descSize.height + 3;
        }
        // 绘制时间
        if (_drawTime) {
            NSString *timeStr = [_dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:data.timeStamp]];
            CGSize timeSize = [timeStr sizeWithAttributes:@{NSFontAttributeName : _timeFont}];
            CGPoint timeAtPoint = CGPointMake(zeroPoint.x - textSize.width / 2, self.height - descHeight - timeSize.height);
            [timeStr drawAtPoint:timeAtPoint withAttributes:@{NSFontAttributeName : _timeFont, NSForegroundColorAttributeName : _descColor}];
        }
    }
}


@end