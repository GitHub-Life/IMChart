//
//  UIView+IMRect.h
//  IMPieChartDemo
//
//  Created by 万涛 on 2018/4/21.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IMRect)

@property (nonatomic, assign) CGFloat im_x;
@property (nonatomic, assign) CGFloat im_y;
@property (nonatomic, assign) CGFloat im_width;
@property (nonatomic, assign) CGFloat im_height;
@property (nonatomic, assign) CGSize im_size;
@property (nonatomic, assign) CGPoint im_origin;

@property (nonatomic, assign) CGFloat im_centerX;
@property (nonatomic, assign) CGFloat im_centerY;

@property (nonatomic, assign, readonly) CGPoint im_centerSelf;

@end
