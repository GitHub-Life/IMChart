//
//  IMChartDataGroup.h
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/24.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMChartData.h"

@interface IMChartDataGroup : NSObject

@property (nonatomic, strong) NSArray<IMChartData *> *dataArray;

- (void)insert:(NSArray<IMChartData *> *)dataArray;

- (void)add:(NSArray<IMChartData *> *)dataArray;

- (NSArray<NSNumber *> *)timeStamps;

@end
