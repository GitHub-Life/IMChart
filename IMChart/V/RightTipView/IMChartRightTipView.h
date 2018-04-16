//
//  IMChartRightTipView.h
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/26.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMChartRightTipView : UIView

@property (nonatomic, strong) NSArray<UIColor *> *textColors;
@property (nonatomic, strong) NSArray<NSString *> *texts;
@property (nonatomic, strong) UIFont *font;

/** Text显示状态集合 0:不显示 非零:显示 */
@property (nonatomic, strong) NSArray<NSNumber *> *showStates;

@end
