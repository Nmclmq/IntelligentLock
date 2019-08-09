//
//  DetailInfoView.m
//  Intelligent Lock
//
//  Created by Matt.S on 16/8/9.
//  Copyright © 2016年 Matt.S. All rights reserved.
//

#import "DetailInfoView.h"

@implementation DetailInfoView

- (id)initWithFrame:(CGRect)frame
{
    frame.size.height += ARROR_HEIGHT;
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    [super drawRect:rect];
}


- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.96 green:0.96 blue:0.93 alpha:1.00].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rect = self.bounds;
    CGFloat radius = 5.0;
    
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect) + ARROR_HEIGHT;
    CGFloat maxY = CGRectGetMaxY(rect);
    
    // 画角
    CGContextMoveToPoint(context, midX - ARROR_HEIGHT, minY);
    CGContextAddLineToPoint(context, midX, minY - ARROR_HEIGHT);
    CGContextAddLineToPoint(context, midX + ARROR_HEIGHT, minY);
    
    
    // 画拐角
    CGContextAddArcToPoint(context, minX, minY, minX, maxY, radius);
    CGContextAddArcToPoint(context, minX, maxY, maxX, maxY, radius);
    CGContextAddArcToPoint(context, maxX, maxY, maxX, minX, radius);
    CGContextAddArcToPoint(context, maxX, minY, midX, minY, radius);
    
    CGContextClosePath(context);
}
//绘图
//CGPoint sPoints[3];//坐标点
//    sPoints[0] =CGPointMake(midX - ARROR_HEIGHT , maxY);//坐标1
//    sPoints[1] =CGPointMake(midX, maxY +   ARROR_HEIGHT);//坐标2
//    sPoints[2] =CGPointMake(midX + ARROR_HEIGHT, maxY);//坐标3
//    CGContextAddLines(context, sPoints, 3);//添加线
//    CGContextClosePath(context);//封起来
//    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
@end
