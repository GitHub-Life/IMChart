//
//  IMChartScrollView.m
//  NiuYan
//
//  Created by 万涛 on 2018/4/13.
//  Copyright © 2018年 niuyan.com. All rights reserved.
//

#import "IMChartScrollView.h"
#import "IMLineChartView.h"
#import "IMColumnChartView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import "UIView+IMRect.h"

#define MinZoomScale 1
#define MaxZoomScale 20
#define ZoomVelocity 5

typedef void(^BeginGrBlock)(void);

@interface IMChartScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat baseScale;
@property (nonatomic, assign) CGFloat pinCenterX;

@property (nonatomic, strong) BeginGrBlock beginGrBlock;

@end

@implementation IMChartScrollView

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

- (void)setBeginGrEventBlock:(void (^)(void))block {
    _beginGrBlock = block;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)initView {
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    self.delegate = self;
    UIPinchGestureRecognizer *pinGr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewPinGrEvent:)];
    [self addGestureRecognizer:pinGr];
    
    _contentView = [[UIView alloc] init];
    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(200);
    }];
    
    _lineChartView = [[IMLineChartView alloc] init];
    [_contentView addSubview:_lineChartView];
    [_lineChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
    }];
    _columnChartView = [[IMColumnChartView alloc] init];
    [_contentView addSubview:_columnChartView];
    @weakify(self);
    [_columnChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.lineChartView.mas_bottom);
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(self.lineChartView.mas_height).multipliedBy(1.0/4);
    }];    
}

- (void)initBind {
    @weakify(self);
    [RACObserve(self, contentWidth) subscribeNext:^(NSNumber *x) {
        CGFloat width = [x doubleValue];
        @strongify(self);
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
        self.lineChartView.width = width;
        self.columnChartView.width = width;
    }];
    [RACObserve(self, drawAreaWidth) subscribeNext:^(NSNumber *x) {
        CGFloat drawAreaWidth = [x doubleValue];
        @strongify(self);
        self.lineChartView.drawAreaWidth = drawAreaWidth;
        self.columnChartView.drawAreaWidth = drawAreaWidth;
    }];
    [RACObserve(self, coordAxisColor) subscribeNext:^(UIColor *x) {
        @strongify(self);
        self.lineChartView.coordAxisColor = x;
        self.columnChartView.coordAxisColor = x;
    }];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _lineChartView.drawBeginOffsetX = scrollView.contentOffset.x;
    _columnChartView.drawBeginOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_beginGrBlock) {
        _beginGrBlock();
    }
}

#pragma mark - ScrollView上的捏合手势 事件
- (void)scrollViewPinGrEvent:(UIPinchGestureRecognizer *)pinGr {
    switch (pinGr.state) {
            case UIGestureRecognizerStateBegan: {
                if (_beginGrBlock) {
                    _beginGrBlock();
                }
                if (pinGr.numberOfTouches >= 2) {
                    _pinCenterX = ([pinGr locationOfTouch:0 inView:_lineChartView].x + [pinGr locationOfTouch:1 inView:_lineChartView].x) / 2;
                }
                self.scale = self.baseScale + (pinGr.scale - 1) * ZoomVelocity;
            } break;
            case UIGestureRecognizerStateChanged: {
                self.scale = self.baseScale + (pinGr.scale - 1) * ZoomVelocity;
            } break;
            case UIGestureRecognizerStateEnded: {
                self.scale = self.baseScale + (pinGr.scale - 1) * ZoomVelocity;
                self.baseScale = self.scale;
            } break;
        default:
            break;
    }
}

- (void)setScale:(CGFloat)scale {
    if (scale < MinZoomScale) {
        scale = MinZoomScale;
    } else if (scale > MaxZoomScale) {
        scale = MaxZoomScale;
    }
    _scale = scale;
    self.contentWidth = self.bounds.size.width * scale;
    CGFloat drawBeginOffsetX = [_lineChartView offsetXWithPinCenterX:_pinCenterX];
    [self setContentOffset:CGPointMake(drawBeginOffsetX, 0)];
    _lineChartView.drawBeginOffsetX = drawBeginOffsetX;
    _columnChartView.drawBeginOffsetX = drawBeginOffsetX;
}

@end
