//
//  IMBothColumnChartView.m
//  IMChartDemo
//
//  Created by 万涛 on 2018/4/18.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMBothColumnChartView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIView+IMRect.h"
#import "IMChartData.h"
#import "IMChartPoint.h"

@interface IMBothColumnChartView ()
/** x轴方向 单位宽度 */
@property (nonatomic, assign) CGFloat unitX;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@property (nonatomic, assign) CGFloat extendLeft;
@property (nonatomic, assign) CGFloat extendRight;

@end

@implementation IMBothColumnChartView

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
        [self initBind];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    _positiveColor = [UIColor redColor];
    _negativeColor = [UIColor greenColor];
    _coordAxisColor = [UIColor lightGrayColor];
    _dataFont = [UIFont systemFontOfSize:10];
    _timeFont = [UIFont systemFontOfSize:10];
    _descFont = [UIFont systemFontOfSize:10];
    _descColor = [UIColor darkGrayColor];
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormat = @"MM-dd";
    _numberFormatter = [[NSNumberFormatter alloc] init];
    _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    _numberFormatter.groupingSeparator = @"";
}

- (void)initBind {
    @weakify(self);
    [RACObserve(self, dataArray) subscribeNext:^(id x) {
        @strongify(self);
        [self setDatasPosition];
        [self setNeedsDisplay];
    }];
    [RACObserve(self, dateFormat) subscribeNext:^(id x) {
        @strongify(self);
        self.dateFormatter.dateFormat = x;
    }];
    [RACObserve(self, fractionalDigits) subscribeNext:^(id x) {
        @strongify(self);
        self.numberFormatter.maximumFractionDigits = [x unsignedIntegerValue];
        self.numberFormatter.minimumFractionDigits = [x unsignedIntegerValue];
    }];
}

- (void)setDatasPosition {
    if (_extendLeft || _extendRight) {
        self.bounds = CGRectMake(_extendLeft, 0, -_extendLeft + self.width - _extendRight, self.height);
        _extendLeft = _extendRight = 0;
    }
    if (_dataArray.count == 0) {
        return;
    }
    _unitX = (self.width - _chartEdgeInsets.left - _chartEdgeInsets.right) / (_dataArray.count * 2 - 1);
    
    CGFloat maxValue = _dataArray.firstObject.columnValue.doubleValue;
    CGFloat minValue = _dataArray.firstObject.columnValue.doubleValue;
    for (IMChartData *data in _dataArray) {
        CGFloat value = data.columnValue.doubleValue;
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
        CGFloat num = data.columnValue.doubleValue;
        CGFloat xPosition = _chartEdgeInsets.left + _unitX / 2 + i * (_unitX * 2);
        IMChartPoint *dataPoint = [IMChartPoint point:xPosition :(unitY > 0 ? (maxY - ((num - minValue) / unitY)) : (maxY + minY) / 2)];
        dataPoint.dataYzeroPoint = [IMChartPoint point:xPosition :(unitY > 0 ? (maxY - (-minValue / unitY)) : (maxY + minY) / 2)];
        dataPoint.index = i;
        data.columnPoint = dataPoint;
    }
    
    if (_chartEdgeInsets.left < _unitX / 2 || _chartEdgeInsets.right < _unitX / 2) {
        _extendLeft = 0;
        if (_chartEdgeInsets.left < _unitX / 2) {
            _extendLeft = _unitX / 2 - _chartEdgeInsets.left;
        }
        _extendRight = 0;
        if (_chartEdgeInsets.right < _unitX / 2) {
            _extendRight = _unitX / 2 - _chartEdgeInsets.right;
        }
        self.bounds = CGRectMake(-_extendLeft, 0, _extendLeft + self.width + _extendRight, self.height);
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
//    CGContextSetLineWidth(context, 0.5);
//    CGContextSetStrokeColorWithColor(context, _coordAxisColor.CGColor);
//    CGContextMoveToPoint(context, 0, _dataArray.firstObject.columnPoint.dataYzeroPoint.y);
//    CGContextAddLineToPoint(context, self.width - _extendLeft - _extendRight, _dataArray.firstObject.columnPoint.dataYzeroPoint.y);
//    CGContextStrokePath(context);
    
    CAShapeLayer *xAxisLayer = [CAShapeLayer layer];
    xAxisLayer.frame = CGRectMake(0, _dataArray.firstObject.columnPoint.dataYzeroPoint.y, self.width - _extendLeft - _extendRight, 0.5);
    [xAxisLayer setBackgroundColor:_coordAxisColor.CGColor];
    [self.layer addSublayer:xAxisLayer];
    
    // 绘制柱状 / 数据 / 描述
    BOOL drawDesc = (_descArray && _descArray.count >= _dataArray.count);
    BOOL drawDataText = (_dataTextArray && _dataTextArray.count >= _dataArray.count);
    CGContextSetLineWidth(context, _unitX);
    // 确定绘制数据的字体大小，使之不超过绘制区域，相互之间不重合
    for (int i = 0; i < _dataArray.count; i++) {
        NSString *text = drawDataText ? _dataTextArray[i] : [_numberFormatter stringFromNumber:_dataArray[i].columnValue];
        CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName : _dataFont}];
        CGFloat dataDrawWidth = (i==0 ? _unitX*1.5+_chartEdgeInsets.left : (i<_dataArray.count-1 ? _unitX*2 : _unitX*1.5+_chartEdgeInsets.right));
        CGFloat dataFontSize = _dataFont.pointSize;
        while (textSize.width > dataDrawWidth) {
            dataFontSize -= 1;
            textSize = [text sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:_dataFont.fontName size:dataFontSize]}];
        }
        _dataFont = [UIFont fontWithName:_dataFont.fontName size:dataFontSize];
        
        if (drawDesc) {
            CGSize descSize = [_descArray[i] sizeWithAttributes:@{NSFontAttributeName : _descFont}];
            CGFloat descFontSize = _descFont.pointSize;
            while (descSize.width > dataDrawWidth) {
                descFontSize -= 1;
                descSize = [_descArray[i] sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:_descFont.fontName size:descFontSize]}];
            }
            _descFont = [UIFont fontWithName:_descFont.fontName size:descFontSize];
        }
        
        if (_drawTime) {
            NSString *timeStr = [_dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_dataArray[i].timeStamp]];
            CGSize timeSize = [timeStr sizeWithAttributes:@{NSFontAttributeName : _timeFont}];
            CGFloat timeFontSize = _timeFont.pointSize;
            while (timeSize.width > dataDrawWidth) {
                timeFontSize -= 1;
                timeSize = [timeStr sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:_timeFont.fontName size:timeFontSize]}];
            }
            _timeFont = [UIFont fontWithName:_timeFont.fontName size:timeFontSize];
        }
    }
    // 开始绘制
    for (int i = 0; i < _dataArray.count; i++) {
        IMChartData *data = _dataArray[i];
        CGFloat num = data.columnValue.doubleValue;
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
        NSString *text = drawDataText ? _dataTextArray[i] : [_numberFormatter stringFromNumber:_dataArray[i].columnValue];
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
            CGPoint timeAtPoint = CGPointMake(zeroPoint.x - timeSize.width / 2, self.height - descHeight - timeSize.height);
            [timeStr drawAtPoint:timeAtPoint withAttributes:@{NSFontAttributeName : _timeFont, NSForegroundColorAttributeName : _descColor}];
        }
    }
}

@end
