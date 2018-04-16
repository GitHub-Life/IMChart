//
//  IMChartChooseView.m
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/26.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMChartChooseView.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface IMChartChooseView ()

@property (nonatomic, strong) UIView *btnBottomLine;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *titleWidths;

@end

@implementation IMChartChooseView

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
    if (!_normalFont) {
        _normalFont = [UIFont systemFontOfSize:14];
    }
    if (!_normalColor) {
        _normalColor = [UIColor grayColor];
    }
}

- (UIView *)btnBottomLine {
    if (!_btnBottomLine) {
        _btnBottomLine = [[UIView alloc] init];
        @weakify(self);
        [RACObserve(self, selectedColor) subscribeNext:^(id x) {
            @strongify(self);
            self.btnBottomLine.backgroundColor = self.selectedColor;
        }];
        [[RACObserve(self, selectedIndex) skip:1] subscribeNext:^(id x) {
            @strongify(self);
            [UIView animateWithDuration:0.3 animations:^{
                [self.btnBottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0);
                    make.height.mas_equalTo(2);
                    make.centerX.mas_equalTo(self.subviews[self.selectedIndex].mas_centerX);
                    make.width.mas_equalTo(self.titleWidths[self.selectedIndex].doubleValue);
                }];
                [self layoutIfNeeded];
            }];
        }];
    }
    return _btnBottomLine;
}

- (NSMutableArray<NSNumber *> *)titleWidths {
    if (!_titleWidths) {
        _titleWidths = [NSMutableArray array];
    }
    return _titleWidths;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setItemTitles:(NSArray<NSString *> *)itemTitles {
    _itemTitles = itemTitles;
    for (UIView *subV in self.subviews) {
        [subV removeFromSuperview];
    }
    if (!_itemTitles || _itemTitles.count == 0) {
        return;
    }
    [self.titleWidths removeAllObjects];
    CGFloat titleWidthSum = 0;
    for (NSString *title in _itemTitles) {
        CGFloat titleW = [title sizeWithAttributes:@{NSFontAttributeName:_normalFont}].width;
        [_titleWidths addObject:@(titleW)];
        titleWidthSum += titleW;
    }
    if (_width == 0) {
        _width = [UIScreen mainScreen].bounds.size.width;
    }
    @weakify(self);
    if (_width > titleWidthSum) {
        CGFloat residueW = _width - titleWidthSum;
        CGFloat btnMargin_H = residueW / (_itemTitles.count * 2);
        CGFloat offsetX = 0;
        for (int i = 0; i < _itemTitles.count; i++) {
            NSString *title = _itemTitles[i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:_normalColor forState:UIControlStateNormal];
            [btn setTitleColor:(_selectedColor ?: _normalColor) forState:UIControlStateSelected];
            if (i == 0) {
                btn.selected = YES;
                btn.titleLabel.font = (_selectedFont ?: _normalFont);
            } else {
                btn.titleLabel.font = _normalFont;
            }
            [self addSubview:btn];
            CGFloat btnW = _titleWidths[i].doubleValue + btnMargin_H * 2;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(offsetX);
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                make.width.mas_equalTo(btnW);
            }];
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
                @strongify(self);
                if (self.selectedIndex == btn.tag) {
                    return;
                }
                UIButton *beforeSelectedBtn = self.subviews[self.selectedIndex];
                beforeSelectedBtn.selected = NO;
                beforeSelectedBtn.titleLabel.font = self.normalFont;
                btn.selected = YES;
                btn.titleLabel.font = (self.selectedFont ?: self.normalFont);
                self.selectedIndex = btn.tag;
            }];
            offsetX += btnW;
        }
    }
    
    [self addSubview:self.btnBottomLine];
    [_btnBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(2);
        make.centerX.mas_equalTo(self.subviews[self.selectedIndex].mas_centerX);
        make.width.mas_equalTo(self.titleWidths[self.selectedIndex].doubleValue);
    }];
}

@end
