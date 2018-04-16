//
//  UIView+Rect.h
//  NiuYan
//
//  Created by 万涛 on 2018/3/15.
//  Copyright © 2018年 niuyan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Rect)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

/** 添加单击手势 */
- (void)addTapGestureRecognizerWithTarget:(id)target action:(SEL)action;

/** 添加长按手势 */
- (void)addLongPressGestureRecognizerWithTarget:(id)target action:(SEL)action;

@end
