//
//  ViewController1.m
//  IMChartDemo
//
//  Created by 万涛 on 2018/4/18.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "ViewController1.h"
#import "IMChart.h"

@interface ViewController1 ()

@property (weak, nonatomic) IBOutlet IMBothColumnChartView *bothColumnChartView;
@property (weak, nonatomic) IBOutlet IMColumnChartView *columnChartView;

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    _bothColumnChartView.chartEdgeInsets = UIEdgeInsetsMake(10, 20, 30, 20);
    _bothColumnChartView.drawTime = YES;
    _bothColumnChartView.descArray = @[@"DESC1", @"DESC2", @"DESC3", @"DESC4", @"DESC5", @"DESC6"];
    
    _columnChartView.chartEdgeInsets = UIEdgeInsetsMake(20, 20, 30, 20);
    _columnChartView.drawTime = YES;
    _columnChartView.descArray = @[@"DESC1", @"DESC2", @"DESC3", @"DESC4", @"DESC5", @"DESC6"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSMutableArray<IMChartData *> *bothColumnDatas = [NSMutableArray array];
    NSMutableArray<IMChartData *> *columnDatas = [NSMutableArray array];
    NSTimeInterval timeStmap = 1524000000;
    for (int i = 0; i < 6; i++) {
        timeStmap += 86400;
        int random = arc4random() % 100;
        [bothColumnDatas addObject:[[IMChartData alloc] initWithColumnValue:(arc4random() % 2 ? @(random) : @(-random)) timeStamp:timeStmap]];
        [columnDatas addObject:[[IMChartData alloc] initWithColumnValue:@(random) timeStamp:timeStmap]];
    }
    _bothColumnChartView.dataArray = bothColumnDatas;
    _columnChartView.dataArray = columnDatas;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
