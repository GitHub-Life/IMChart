//
//  IMChartData+Parse.m
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/24.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMChartData+Parse.h"

@implementation IMChartData (Parse)

+ (NSArray<IMChartData *> *)dataArrayWithResponseDatas:(NSArray *)responseDatas {
    NSMutableArray<IMChartData *> *dataArray = [NSMutableArray array];
    for (NSArray *dataDict in responseDatas) {
        IMChartData *data = [[IMChartData alloc] init];
        data.lineValues = @[dataDict[4], dataDict[1], dataDict[2]];
        data.columeValue = dataDict[3];
        data.timeStamp = [dataDict[0] doubleValue];
        [dataArray addObject:data];
    }
    return dataArray;
}

@end
