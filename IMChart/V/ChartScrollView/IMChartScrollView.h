//
//  IMChartScrollView.h
//  NiuYan
//
//  Created by 万涛 on 2018/4/13.
//  Copyright © 2018年 niuyan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IMLineChartView;
@class IMColumnChartView;

@interface IMChartScrollView : UIScrollView

@property (nonatomic, strong) IMLineChartView *lineChartView;
@property (nonatomic, strong) IMColumnChartView *columnChartView;

@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat drawAreaWidth;
@property (nonatomic, copy) UIColor *coordAxisColor;

/** 设置开始手势时调用的Block */
- (void)setBeginGrEventBlock:(void(^)(void))block;

@end
