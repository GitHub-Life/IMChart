//
//  IMChartData+Parse.h
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/24.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMChartData.h"

@interface IMChartData (Parse)

+ (NSArray<IMChartData *> *)dataArrayWithResponseDatas:(NSArray *)responseDatas;

@end
