//
//  IMChartRightTipView.m
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/26.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMChartRightTipView.h"
#import <Masonry/Masonry.h>

@implementation IMChartRightTipView

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
        _font = [UIFont systemFontOfSize:12];
    }
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setShowStates:(NSArray<NSNumber *> *)showStates {
    _showStates = showStates;
    for (UIView *subV in self.subviews) {
        [subV removeFromSuperview];
    }
    if (!_showStates || !_texts || !_textColors) {
        return;
    }
    
    NSInteger showCount = MIN(MIN(_texts.count, _textColors.count), _showStates.count);
    if (showCount == 0) {
        return;
    }
    NSMutableArray<NSString *> *texts = [NSMutableArray array];
    NSMutableArray<UIColor *> *textColors = [NSMutableArray array];
    for (int i = 0; i < showCount; i++) {
        if (_showStates[i].boolValue) {
            [texts addObject:_texts[i]];
            [textColors addObject:_textColors[i]];
        }
    }
    [self setTexts:texts textColors:textColors];
}

- (void)setTexts:(NSArray<NSString *> *)texts textColors:(NSArray<UIColor *> *)textColors {
    for (UIView *subV in self.subviews) {
        [subV removeFromSuperview];
    }
    if (!texts || !textColors) {
        return;
    }
    NSInteger showCount = MIN(texts.count, textColors.count);
    if (showCount == 0) {
        return;
    }
    CGFloat labelW = self.frame.size.height / showCount;
    CGFloat labelH = self.frame.size.width;
    CGFloat offsetY = (labelW - labelH) / 2;
    for (int i = 0; i < showCount; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColors[i];
        label.font = _font;
        label.text = texts[i];
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(labelW);
            make.height.mas_equalTo(labelH);
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(offsetY);
        }];
        label.transform = CGAffineTransformMakeRotation(M_PI_2);
        offsetY += labelW;
    }
}

@end
