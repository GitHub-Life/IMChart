//
//  IMSmoothedLineChartPainer.h
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/24.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IMChartData;

@interface IMSmoothedLineChartPainer : NSObject

@property (nonatomic, assign) BOOL gradientFill;

@property (nonatomic, assign) CGSize drawSize;

- (void)drawWithDataArray:(NSArray<IMChartData *> *)dataArray context:(CGContextRef)context lineColors:(NSArray<UIColor *> *)lineColors lineShowStates:(NSArray<NSNumber *> *)lineShowStates;

@end
