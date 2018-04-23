//
//  UIView+IMRect.m
//  NiuYan
//
//  Created by 万涛 on 2018/3/15.
//  Copyright © 2018年 niuyan.com. All rights reserved.
//

#import "UIView+IMRect.h"

@implementation UIView (Rect)

-(void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(CGFloat)x
{
    return CGRectGetMinX(self.frame);
}

-(void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(CGFloat)y
{
    return CGRectGetMinY(self.frame);
}

-(void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(CGFloat)width
{
    return CGRectGetWidth(self.frame);
}

-(void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(CGFloat)height {
    return CGRectGetHeight(self.frame);
}

-(void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

-(CGSize)size {
    return self.frame.size;
}

-(void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

-(CGPoint)origin {
    return self.frame.origin;
}

-(void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

-(CGFloat)centerX {
    return CGRectGetMidX(self.frame);
}

-(void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

-(CGFloat)centerY {
    return CGRectGetMidY(self.frame);
}

@end
