//
//  WindParticle.m
//  windMap
//
//  Created by 卢大维 on 14/12/25.
//  Copyright (c) 2014年 weather. All rights reserved.
//

#import "WindParticle.h"

@interface WindParticle ()

@property (nonatomic) CGFloat vScale;       // 速度比例
@property (nonatomic) CGFloat initAge;
@property (nonatomic) BOOL isRight;
@property (nonatomic,strong) UIColor *color;

@end

@implementation WindParticle

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(instancetype)init
{
    if (self = [super init]) {
        
        self.vScale = 10.0;
        self.oldCenter = CGPointMake(-1, -1);
    }
    
    return self;
}

-(void)setVelocityWithX:(CGFloat)x y:(CGFloat)y
{
    self.xv = x/self.vScale;
    self.yv = y/self.vScale;
    
    CGFloat s = sqrt(x*x + y*y)/self.maxLength;
#if 1
    CGFloat t = floor(290*(1 - s)) - 45;
    _color = [UIColor colorWithHue:t/255.0 saturation:0.8f brightness:self.isRight?1.0f:0.5f alpha:0.8f];
#else
    CGFloat t = floor(255*(1 - s));
#endif
}

-(void)resetWithCenter:(CGPoint)center age:(NSInteger)age xv:(CGFloat)xv yv:(CGFloat)yv colorBright:(BOOL)isRight
{
    self.isRight = isRight;
    self.age = age;
    self.initAge = age;
    [self updateWithCenter:center xv:xv yv:yv];
    
    self.oldCenter = CGPointMake(-1, -1);
}

-(UIColor *)color
{
    return _color;
}

-(CGFloat)initAge
{
    return _initAge;
}

-(CGFloat)length
{
    if (self.oldCenter.x == -1) {
        return 5;
    }
    return self.vScale * sqrt((self.center.x-self.oldCenter.x)*(self.center.x-self.oldCenter.x) + (self.center.y-self.oldCenter.y)*(self.center.y-self.oldCenter.y));
}

-(CGFloat)angleWithXY
{
    CGFloat angle = atan2(self.yv, self.xv);
    if (self.oldCenter.x != -1) {
        if (self.center.x == self.oldCenter.x) {
            angle = ((self.center.y > self.oldCenter.y)?1:-1)*M_PI_2;
        }
        else if (self.center.y == self.oldCenter.y)
        {
            angle = (self.center.x > self.oldCenter.x)?0:M_PI;
        }
        else
        {
            angle = atan2(self.center.y - self.oldCenter.y, self.center.x - self.oldCenter.x);
        }
    }
    
    return angle;
}

-(void)updateWithCenter:(CGPoint)center xv:(CGFloat)xv yv:(CGFloat)yv
{
    self.oldCenter = self.center;
    self.center = center;
    [self setVelocityWithX:xv y:yv];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"center: %@, xv: %.2f, yv: %.2f, color:%@", [NSValue valueWithCGPoint:self.center], self.xv, self.yv, self.color];
}
@end
