//
//  ViewController1.m
//  IMChartDemo
//
//  Created by 万涛 on 2018/4/18.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "ViewController1.h"
#import "IMBothColumnChartView.h"
#import "IMChartData.h"

@interface ViewController1 ()

@property (weak, nonatomic) IBOutlet IMBothColumnChartView *bothColumnChartView;

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    _bothColumnChartView.chartEdgeInsets = UIEdgeInsetsMake(10, 20, 30, 20);
    _bothColumnChartView.drawTime = YES;
    _bothColumnChartView.descArray = @[@"DESC1", @"DESC2", @"DESC3", @"DESC4", @"DESC5", @"DESC6"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSMutableArray<IMChartData *> *datas = [NSMutableArray array];
    NSTimeInterval timeStmap = 1524000000;
    for (int i = 0; i < 6; i++) {
        timeStmap += 86400;
        IMChartData *data = [[IMChartData alloc] init];
        int random = arc4random() % 100;
        data.columeValue = arc4random() % 2 ? @(random) : @(-random);
        data.timeStamp = timeStmap;
        [datas addObject:data];
    }
    _bothColumnChartView.dataArray = datas;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
