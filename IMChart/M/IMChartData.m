//
//  IMChartData.m
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/24.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMChartData.h"

@implementation IMChartData

- (instancetype)initWithColumnValue:(NSNumber *)columnValue timeStamp:(NSTimeInterval)timeStamp {
    if (self = [super init]) {
        _columnValue = columnValue;
        _timeStamp = timeStamp;
    }
    return self;
}

+ (instancetype)dataWithLineValues:(NSArray<NSNumber *> *)lineValues {
    IMChartData *data = [[IMChartData alloc] init];
    data.lineValues = lineValues;
    return data;
}

+ (instancetype)dataWithLineValue:(NSNumber *)lineValue {
    IMChartData *data = [[IMChartData alloc] init];
    data.lineValues = @[lineValue];
    return data;
}

@end
