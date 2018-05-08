//
//  ViewController.m
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/24.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "IMChart.h"
#import "IMChartData+Parse.h"

#define ChartViewWidth ([UIScreen mainScreen].bounds.size.width - 58)

@interface ViewController ()
    
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
    
- (IMTrendColumnChartView *)columnChartView {
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
    _timeChooseStrs = @[@"1d", @"7d", @"1m", @"3m", @"1y", @"ytd", @"all"];
//    _chooseView.itemTitles = @[@"天", @"周", @"1月", @"3月", @"1年", @"今年", @"所有"];
    _chooseView.itemTitles = _timeChooseStrs;
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
    [_lineChartRightTipView setTexts:@[@"Value1", @"Value2", @"Value3"]];
    
    [_columnChartRightTipView setFont:[UIFont systemFontOfSize:12]];
    [_columnChartRightTipView setTextColors:@[self.chartColors.lastObject]];
    [_columnChartRightTipView setTexts:@[@"Value4"]];
    
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
        [self getDataWithParams:self.timeChooseStrs[[x integerValue]]];
    }];
    [RACObserve(self.lineChartView, timeStamps) subscribeNext:^(id x) {
        @strongify(self);
        self.timeLineView.timeStamps = x;
    }];
}
    
- (void)getDataWithParams:(NSString *)params {
    @weakify(self);
    dispatch_async(dispatch_queue_create(nil, nil), ^{
        NSError *error;
        NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:params ofType:@"json"];
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonFilePath] options:NSJSONReadingMutableContainers error:&error];
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dataGroup.dataArray = [IMChartData dataArrayWithResponseDatas:jsonArray];
            });
        } else {
            NSLog(@"error = %@", error.description);
        }
    });
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
