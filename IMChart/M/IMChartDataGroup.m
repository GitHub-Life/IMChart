//
//  IMChartDataGroup.m
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/24.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMChartDataGroup.h"

@implementation IMChartDataGroup

- (instancetype)init {
    if (self = [super init]) {
        _dataArray = [NSArray array];
    }
    return self;
}

- (void)insert:(NSArray<IMChartData *> *)dataArray {
    self.dataArray = [dataArray arrayByAddingObjectsFromArray:self.dataArray];
}

- (void)add:(NSArray<IMChartData *> *)dataArray {
    self.dataArray = [self.dataArray arrayByAddingObjectsFromArray:dataArray];
}

- (NSArray<NSNumber *> *)timeStamps {
    NSMutableArray<NSNumber *> *timeStamps = [NSMutableArray array];
    for (IMChartData *data in _dataArray) {
        [timeStamps addObject:@(data.timeStamp)];
    }
    return timeStamps;
}

@end
