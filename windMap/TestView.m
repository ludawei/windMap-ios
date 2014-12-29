//
//  TestView.m
//  windMap
//
//  Created by 卢大维 on 14/12/29.
//  Copyright (c) 2014年 weather. All rights reserved.
//

#import "TestView.h"

@interface TestView ()

@end

@implementation TestView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:(CGRect)frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect{
    /**
     * UIKit坐标系，原点在UIView左上角
     */
    CGContextRef context =  UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
//    CGAffineTransform transform;
//    
//    /**
//     * 变换后 transform = CBA,显然不是想要的结果.
//     * 这是由于CGAffineTransform变换函数构造的矩阵在左边,如:
//     * t' = CGAffineTransformTranslate(t,tx,ty)
//     * 结果为:t' = [ 1 0 0 1 tx ty ] * t
//     * 累积变换就会得到上面的结果
//     */
//    transform = CGAffineTransformIdentity;
//    transform = CGAffineTransformTranslate(transform, -50, -50); //A
//    transform = CGAffineTransformRotate(transform, M_PI_4);      //B
//    transform = CGAffineTransformTranslate(transform, 50, 50);   //C
//    
//    
//    /**
//     * 为了得到正确结果,调整顺序如下:
//     */
//    transform = CGAffineTransformIdentity;
//    transform = CGAffineTransformTranslate(transform, 50, 50);    //C
//    transform = CGAffineTransformRotate(transform, M_PI_4);       //B
//    transform = CGAffineTransformTranslate(transform, -50, -50);  //A
//    CGContextConcatCTM(context, transform);
    
    /**
     * context函数变换
     */
    CGPoint point = CGPointMake(50, 50);
    
    CGContextTranslateCTM(context, point.x, point.y);    //C
    CGContextRotateCTM(context, M_PI_4);       //B
//    CGContextTranslateCTM(context, -50, -50);  //A
    
    /**
     * 绘制矩形
     */
//    CGContextFillRect(context, CGRectMake(0, 0, 20, 10));
//    CGContextFillRect(context, CGRectMake(self.bounds.size.width/2-10, self.bounds.size.height/2-5, 20, 10));
//    CGContextFillRect(context, CGRectMake(300, 558, 20, 10));
//    
//    CGContextFillRect(context, CGRectMake(300, 0, 20, 10));
//    CGContextFillRect(context, CGRectMake(300, -45, 20, 10));
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    
    CGContextMoveToPoint(context, point.x, point.y);
    
    point = CGPointMake(point.x + 30, point.y + 10);
    CGContextAddLineToPoint(context, point.x, point.y);
    
    point = CGPointMake(point.x - 20, point.y + 10);
    CGContextAddLineToPoint(context, point.x, point.y);
    
    CGContextClosePath(context);
    CGContextFillPath(context);
//    CGContextStrokePath(context);
    
//    CGPoint point1 = CGPointMake(150, 150);
//    point1 = [self translatePointWithPoint:point1 angle:M_PI_4];
//    CGContextMoveToPoint(context, point1.x, point1.y);
//    
//    point1 = CGPointMake(point1.x + 30, point1.y + 10);
//    point1 = [self translatePointWithPoint:point1 angle:M_PI_4];
//    CGContextAddLineToPoint(context, point1.x, point1.y);
//    
//    point1 = CGPointMake(point1.x - 20, point1.y + 10);
//    point1 = [self translatePointWithPoint:point1 angle:M_PI_4];
//    CGContextAddLineToPoint(context, point1.x, point1.y);
    
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
}

-(CGPoint)translatePointWithPoint:(CGPoint)point angle:(CGFloat)angle
{
    CGFloat l = sqrt(point.x*point.x + point.y+point.y);
    CGFloat angle0 = atan2(point.y, point.x);
    CGFloat angle1 = angle + angle0;
    
    CGPoint tPoint = CGPointMake(l * cos(angle1), l * sin(angle1));
    
    return tPoint;
}
@end
