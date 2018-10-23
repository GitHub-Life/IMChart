//
//  IMLineChartView.m
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/24.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMLineChartView.h"
#import "IMChartDataGroup.h"
#import "IMSmoothedLineChartPainer.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIView+IMRect.h"
#import "IMChartPoint.h"

@interface IMLineChartView ()

/** X轴方向 单位宽度 */
@property (nonatomic, assign) CGFloat unitX;

@property (nonatomic, strong) NSArray<IMChartData *> *drawDataArray;

@end

@implementation IMLineChartView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
    _yReferenceCount = 5;
    _hideYReference = NO;
    _coordAxisColor = [UIColor lightGrayColor];
    _lineWidth = 1.0f;
    _yStartZero = NO;
    _smoothed = YES;
    _lineColors = @[[UIColor blueColor]];
    _lineShowStates = @[@1];
    _dataGroup = [[IMChartDataGroup alloc] init];
    @weakify(self);
    [[RACSignal combineLatest:@[RACObserve(self.dataGroup, dataArray), RACObserve(self, lineShowStates)]] subscribeNext:^(id x) {
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
    
    CGContextSetLineWidth(context, _lineWidth);
    if (_smoothed) {
        IMSmoothedLineChartPainer *painer = [[IMSmoothedLineChartPainer alloc] init];
        painer.gradientFill = _gradientFill;
        painer.drawSize = rect.size;
        [painer drawWithDataArray:_drawDataArray context:context lineColors:_lineColors lineShowStates:_lineShowStates];
    }
    
    if (_drawAnimation) {
        [self addAnimation];
    }
}

#pragma mark - 添加绘制动画
- (void)addAnimation {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.lineWidth = CGRectGetHeight(self.bounds);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, CGRectGetHeight(self.bounds) / 2)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) / 2)];
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.duration = 1;
    anim.fromValue = @(0);
    anim.toValue = @(1);
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayer addAnimation:anim forKey:@"strokeEnd"];
}

- (void)draw {
    if (_yStartZero) {
        
    } else {
        [self setDatasPosition_yStartMin];
    }
    [self setNeedsDisplay];
}

// 当有两条线段基本重合的时候 使用此算法将 曲线区分
- (void)setDatasPosition_yStartMin {
    if (_dataGroup.dataArray.count == 0) {
        return;
    }
    if (_dataGroup.dataArray.count > 1) {
        _unitX = self.frame.size.width / (_dataGroup.dataArray.count - 1);
    } else {
        _unitX = self.frame.size.width;
    }
    
    NSInteger beginIndex = MAX(_drawBeginOffsetX / _unitX, 0);
    NSInteger endIndex = MIN((_drawBeginOffsetX + _drawAreaWidth) / _unitX + 1, _dataGroup.dataArray.count - 1);
    if (beginIndex > endIndex) {
        beginIndex = 0;
    }
    _drawDataArray = [_dataGroup.dataArray subarrayWithRange:NSMakeRange(beginIndex, endIndex - beginIndex + 1)];
    
    NSMutableArray<NSNumber *> *timeStamps = [NSMutableArray array];
    NSMutableArray<NSNumber *> *maxValues = _drawDataArray.firstObject.lineValues.mutableCopy;
    NSMutableArray<NSNumber *> *minValues = _drawDataArray.firstObject.lineValues.mutableCopy;
    for (IMChartData *data in _drawDataArray) {
        [timeStamps addObject:@(data.timeStamp)];
        for (int i = 0; i < maxValues.count; i++) {
            if (data.lineValues[i].doubleValue > maxValues[i].doubleValue) {
                maxValues[i] = data.lineValues[i];
            }
            if (data.lineValues[i].doubleValue < minValues[i].doubleValue) {
                minValues[i] = data.lineValues[i];
            }
        }
    }
    self.timeStamps = timeStamps;
    
    /** 是否有曲线重合【注：这里判断第一条曲线 与 第二条曲线】 */
    BOOL overlap = (_lineShowStates.count > 2 && [_lineShowStates[0] boolValue] && [_lineShowStates[1] boolValue]);
    
    for (int i = 0; i < maxValues.count; i++) {
        CGFloat max = maxValues[i].doubleValue;
        CGFloat min = minValues[i].doubleValue;
        CGFloat diff = (max - min) * 0.05;
        if (overlap && i == 0) { // 当重合的时候，将第一条线段的点下移
            max += diff * 3;
        }
        maxValues[i] = @(max + diff);
        minValues[i] = @(min - diff);
    }
    
    CGFloat minY = 0;
    CGFloat maxY = self.frame.size.height;
    NSMutableArray<NSNumber *> *unitValues = [NSMutableArray array];
    for (int i = 0; i < maxValues.count; i++) {
        [unitValues addObject:@((maxValues[i].doubleValue - minValues[i].doubleValue) / (maxY - minY))];
    }
    
    for (int i = 0; i < _drawDataArray.count; i++) {
        IMChartData *data = _drawDataArray[i];
        CGFloat xPosition = (beginIndex + i) * _unitX;
        NSMutableArray<IMChartPoint *> *points = [NSMutableArray array];
        for (int j = 0; j < data.lineValues.count; j++) {
            [points addObject:[IMChartPoint point:xPosition :maxY - (unitValues[j].doubleValue > 0 ? ((data.lineValues[j].doubleValue - minValues[j].doubleValue) / unitValues[j].doubleValue) : 0)]];
        }
        data.linePoints = points;
    }
}

- (IMChartData *)dataWithPoint:(CGPoint)point {
    point.y = 0;
    if (CGRectContainsPoint(self.bounds, point) && _unitX > 0) {
        NSInteger index = round(point.x / _unitX);
        if (index < _dataGroup.dataArray.count) {
            return _dataGroup.dataArray[index];
        }
    }
    return nil;
}

- (CGFloat)offsetXWithPinCenterX:(CGFloat)pinCenterX {
    CGFloat unitX = 0;
    if (_dataGroup.dataArray.count == 0) {
        return unitX;
    }
    if (_dataGroup.dataArray.count > 1) {
        unitX = self.im_width / (_dataGroup.dataArray.count - 1);
    } else {
        unitX = self.im_width;
    }
    // 得出手势中心点在绘制区域中的相对位置
    CGFloat pinCenterXoffset = pinCenterX - _drawBeginOffsetX;
    // 计算缩放前所在位置的数据索引
    NSInteger pinCenterIndex = round(pinCenterX / _unitX);
    // 得出缩放后这个索引数据位置的X
    CGFloat newPinCenterX = pinCenterIndex * unitX;
    if (newPinCenterX < pinCenterXoffset) {
        return 0;
    } else if (self.im_width - _drawBeginOffsetX < _drawAreaWidth) {
        return self.im_width - _drawAreaWidth;
    }
    return newPinCenterX - pinCenterXoffset;
}

@end
