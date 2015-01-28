//
//  WindParticle.h
//  windMap
//
//  Created by 卢大维 on 14/12/25.
//  Copyright (c) 2014年 weather. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WindParticle : NSObject

@property (nonatomic) NSInteger age;
@property (nonatomic) CGFloat xv;           // x速度
@property (nonatomic) CGFloat yv;           // y速度
@property (nonatomic) CGFloat maxLength;
@property (nonatomic) CGPoint center;
@property (nonatomic) CGPoint oldCenter;

@property (nonatomic) CGFloat colorHue;

-(void)resetWithCenter:(CGPoint)center age:(NSInteger)age xv:(CGFloat)xv yv:(CGFloat)yv;
-(void)updateWithCenter:(CGPoint)center xv:(CGFloat)xv yv:(CGFloat)yv;
-(CGFloat)angleWithXY;
-(CGFloat)initAge;
-(CGFloat)length;
-(BOOL)isShow;
@end
