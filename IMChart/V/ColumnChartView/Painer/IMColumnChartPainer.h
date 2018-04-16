//
//  IMColumnChartPainer.h
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/26.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IMChartData;

@interface IMColumnChartPainer : NSObject

- (void)drawWithDataArray:(NSArray<IMChartData *> *)dataArray context:(CGContextRef)context;

@end
