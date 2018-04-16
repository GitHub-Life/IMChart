//
//  ViewController.m
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/24.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "IMChart.h"
#import "IMChartData+Parse.h"

#define ChartViewWidth ([UIScreen mainScreen].bounds.size.width - 58)

@interface ViewController ()
    
@property (nonatomic, copy) NSString *coinId;
    
@property (nonatomic, strong) NSArray<UIColor *> *chartColors;

@property (nonatomic, strong) IMChartDataGroup *dataGroup;
@property (nonatomic, strong) NSArray<NSNumber *> *showStates;
    @property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *showStateBtns;
    
@property (nonatomic, strong) NSArray<NSString *> *timeChooseStrs;
@property (weak, nonatomic) IBOutlet IMChartChooseView *chooseView;
@property (weak, nonatomic) IBOutlet IMChartScrollView *chartScrollView;
@property (weak, nonatomic) IBOutlet IMChartRightTipView *lineChartRightTipView;
@property (weak, nonatomic) IBOutlet IMChartRightTipView *columnChartRightTipView;
@property (weak, nonatomic) IBOutlet IMChartTimeLineView *timeLineView;
@property (nonatomic, strong) NSArray<NSString *> *timeLineDateFormats;

@end

@implementation ViewController

- (IMChartDataGroup *)dataGroup {
    if (!_dataGroup) {
        _dataGroup = [[IMChartDataGroup alloc] init];
    }
    return _dataGroup;
}
    
- (IMLineChartView *)lineChartView {
    return _chartScrollView.lineChartView;
}
    
- (IMColumnChartView *)columnChartView {
    return _chartScrollView.columnChartView;
}
    
- (NSArray<UIColor *> *)chartColors {
    if (!_chartColors) {
        _chartColors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor darkGrayColor]];
    }
    return _chartColors;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initBind];
}
    
- (void)initView {
    _coinId = @"bitcoin";
    
    _timeChooseStrs = @[@"1d", @"7d", @"1m", @"3m", @"1y", @"ytd", @"all"];
    _chooseView.itemTitles = @[@"天", @"周", @"1月", @"3月", @"1年", @"今年", @"所有"];
    [_chooseView setNormalFont:[UIFont systemFontOfSize:14]];
    [_chooseView setNormalColor:[UIColor blackColor]];
    [_chooseView setSelectedFont:[UIFont systemFontOfSize:14 weight:UIFontWeightBold]];
    [_chooseView setSelectedColor:[UIColor blueColor]];
    
    _chartScrollView.contentWidth = ChartViewWidth;
    _chartScrollView.drawAreaWidth = ChartViewWidth;
    _chartScrollView.coordAxisColor = [UIColor lightGrayColor];
//    [_chartScrollView setBeginGrEventBlock:^{
//        // ScrollView开始滑动、缩放手势回调
//    }];
    
    _showStates = @[@1,@1,@1,@1];
    [self.lineChartView setLineColors:[self.chartColors subarrayWithRange:NSMakeRange(0, 3)]];
    [self.columnChartView setColumnColor:[self.chartColors lastObject]];
    
    [_lineChartRightTipView setFont:[UIFont systemFontOfSize:12]];
    [_lineChartRightTipView setTextColors:[self.chartColors subarrayWithRange:NSMakeRange(0, 3)]];
    [_lineChartRightTipView setTexts:@[@"市值", @"价格(USD)", @"价格(BTC)"]];
    
    [_columnChartRightTipView setFont:[UIFont systemFontOfSize:12]];
    [_columnChartRightTipView setTextColors:@[self.chartColors.lastObject]];
    [_columnChartRightTipView setTexts:@[@"24H成交额"]];
    
    _timeLineView.width = ChartViewWidth;
    _timeLineDateFormats = @[@"HH:mm", @"MM-dd", @"MM-dd", @"MM-dd", @"yyyy-MM", @"MM-dd", @"yyyy-MM"];
}
    
- (void)initBind {
    @weakify(self);
    [RACObserve(self, showStates) subscribeNext:^(id x) {
        @strongify(self);
        self.lineChartView.lineShowStates = x;
        self.lineChartRightTipView.showStates = x;
        self.columnChartView.hidden = ![[x lastObject] boolValue];
        self.columnChartRightTipView.showStates = @[[x lastObject]];
    }];
    [RACObserve(self.dataGroup, dataArray) subscribeNext:^(id x) {
        @strongify(self);
        self.lineChartView.dataGroup.dataArray = x;
        self.columnChartView.dataGroup.dataArray = x;
    }];
    [RACObserve(_chooseView, selectedIndex) subscribeNext:^(id x) {
        @strongify(self);
        [self.timeLineView setDateFormat:self.timeLineDateFormats[[x integerValue]]];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"coin_id"] = self.coinId;
        if ([x integerValue] < self.timeChooseStrs.count) {
            params[@"type"] = self.timeChooseStrs[[x integerValue]];
        }
        [self getDataWithParams:params];
    }];
    [RACObserve(self.lineChartView, timeStamps) subscribeNext:^(id x) {
        @strongify(self);
        self.timeLineView.timeStamps = x;
    }];
}
    
- (void)getDataWithParams:(NSDictionary *)params {
    @weakify(self);
    [[AFHTTPSessionManager manager] GET:@"https://market.niuyan.com/api/v2/web/coin/chart" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * responseDict) {
        @strongify(self);
        if ([responseDict[@"code"] intValue] == 0) {
            self.dataGroup.dataArray = [IMChartData dataArrayWithResponseDatas:responseDict[@"data"][@"data"]];
        } else {
            NSLog(@" - 数据请求错误 - ");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@", error.description);
    }];
}

- (IBAction)showStateBtnsClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    NSMutableArray<NSNumber *> *showStates = [NSMutableArray array];
    for (UIButton *btn in _showStateBtns) {
        [showStates addObject:@(btn.isSelected)];
    }
    self.showStates = showStates;
}
    
@end
