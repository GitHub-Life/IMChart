//
//  IMChartChooseView.h
//  IMChartDemo
//
//  Created by 万涛 on 2018/3/26.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMChartChooseView : UIView

/** 本视图宽度，默认为屏幕宽度，要设置的话，请在设置 itemTitles 之前设置此值 */
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, strong) NSArray<NSString *> *itemTitles;

@property (nonatomic, strong) UIFont *normalFont;
@property (nonatomic, strong) UIFont *selectedFont;

@property (nonatomic, strong) IBInspectable UIColor *normalColor;
@property (nonatomic, strong) IBInspectable UIColor *selectedColor;

@property (nonatomic, assign) NSInteger selectedIndex;

@end
