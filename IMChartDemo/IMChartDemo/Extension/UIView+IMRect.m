//
//  UIView+IMRect.m
//  IMPieChartDemo
//
//  Created by 万涛 on 2018/4/21.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "UIView+IMRect.h"

@implementation UIView (IMRect)

-(void)setIm_x:(CGFloat)im_x {
    CGRect frame = self.frame;
    frame.origin.x = im_x;
    self.frame = frame;
}

-(CGFloat)im_x {
    return CGRectGetMinX(self.frame);
}

-(void)setIm_y:(CGFloat)im_y {
    CGRect frame = self.frame;
    frame.origin.y = im_y;
    self.frame = frame;
}

-(CGFloat)im_y {
    return CGRectGetMinY(self.frame);
}

-(void)setIm_width:(CGFloat)im_width {
    CGRect frame = self.frame;
    frame.size.width = im_width;
    self.frame = frame;
}

-(CGFloat)im_width {
    return CGRectGetWidth(self.frame);
}

-(void)setIm_height:(CGFloat)im_height {
    CGRect frame = self.frame;
    frame.size.height = im_height;
    self.frame = frame;
}

-(CGFloat)im_height {
    return CGRectGetHeight(self.frame);
}

-(void)setIm_size:(CGSize)im_size {
    CGRect frame = self.frame;
    frame.size = im_size;
    self.frame = frame;
}

-(CGSize)im_size {
    return self.frame.size;
}

-(void)setIm_origin:(CGPoint)im_origin {
    CGRect frame = self.frame;
    frame.origin = im_origin;
    self.frame = frame;
}

-(CGPoint)im_origin {
    return self.frame.origin;
}

-(void)setIm_centerX:(CGFloat)im_centerX {
    CGPoint center = self.center;
    center.x = im_centerX;
    self.center = center;
}

-(CGFloat)im_centerX {
    return CGRectGetMidX(self.frame);
}

-(void)setIm_centerY:(CGFloat)im_centerY {
    CGPoint center = self.center;
    center.y = im_centerY;
    self.center = center;
}

-(CGFloat)im_centerY {
    return CGRectGetMidY(self.frame);
}

- (CGPoint)im_centerSelf {
    return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}

@end
