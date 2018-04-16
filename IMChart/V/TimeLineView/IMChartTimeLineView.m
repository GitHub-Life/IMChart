//
//  IMChartTimeLineView.m
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/26.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMChartTimeLineView.h"
#import <Masonry/Masonry.h>

@interface IMChartTimeLineView ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation IMChartTimeLineView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initSetting];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initSetting];
    }
    return self;
}

- (void)initSetting {
    if (!_font) {
        _font = [UIFont systemFontOfSize:11];
    }
    if (!_textColor) {
        _textColor = [UIColor grayColor];
    }
    if (!_referenceColor) {
        _referenceColor = [UIColor groupTableViewBackgroundColor];
    }
    if (_showCount <= 0) {
        _showCount = 4;
    }
    if (_dateFormat <= 0) {
        _dateFormat = @"d.MMM";
    }
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    self.backgroundColor = [UIColor clearColor];
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = _dateFormat;
    }
    return _dateFormatter;
}

- (void)setDateFormat:(NSString *)dateFormat {
    _dateFormat = dateFormat;
    self.dateFormatter.dateFormat = dateFormat;
}

/**
 *   |                 |                 |                 |
 *   |--------|--------|--------|--------|--------|--------|
 * start    show               show              show     end
 */
- (void)setTimeStamps:(NSArray<NSNumber *> *)timeStamps {
    _timeStamps = timeStamps;
    for (UIView *subV in self.subviews) {
        [subV removeFromSuperview];
    }
    if (!_timeStamps || _timeStamps.count == 0 || _showCount == 0) {
        return;
    }
    if (_width == 0) {
        _width = [UIScreen mainScreen].bounds.size.width;
    }
    NSInteger showCount = MIN(_showCount, _timeStamps.count);
    CGFloat indexStep = _timeStamps.count * 1.0f / (showCount * 2);
    CGFloat xStep = _width / (showCount * 2);
    for (int i = 0; i < showCount; i++) {
        NSTimeInterval timeStamp = _timeStamps[(NSInteger)((2 * i + 1) * indexStep)].doubleValue;
        CGFloat centerX = (2 * i + 1) * xStep;
        UILabel *label = [[UILabel alloc] init];
        label.font = _font;
        label.textColor = _textColor;
        label.text = [_dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeStamp]];
        CGFloat textW = [label.text sizeWithAttributes:@{NSFontAttributeName : _font}].width;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.leading.mas_equalTo(centerX - (textW / 2));
        }];
        UIView *referenceLine = [[UIView alloc] init];
        referenceLine.backgroundColor = _referenceColor;
        [self addSubview:referenceLine];
        [referenceLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.leading.mas_equalTo(centerX - 0.5);
            make.width.mas_equalTo(1);
            make.bottom.mas_equalTo(label.mas_top);
        }];
    }
}

@end
