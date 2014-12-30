//
//  WindParticle.m
//  windMap
//
//  Created by 卢大维 on 14/12/25.
//  Copyright (c) 2014年 weather. All rights reserved.
//

#import "WindParticle.h"

#define S_HEIGHT_RADIO 0.5
#define S_WIDTH_RADIO 0.6

#define PARTICLE_WIDTH 10
#define PARTICLE_HEIGHT 6

@interface WindParticle ()

@property (nonatomic) CGFloat vScale;       // 速度比例
@property (nonatomic) CGPoint oldCenter;

@end

@implementation WindParticle

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(instancetype)init
{
    if (self = [super init]) {
        
        self.vScale = 8.0;
        self.oldCenter = CGPointMake(-1, -1);
    }
    
    return self;
}

-(void)setVelocityWithX:(CGFloat)x y:(CGFloat)y
{
    self.xv = x/self.vScale;
    self.yv = y/self.vScale;
    
//    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, [self angleWithXY]);
    
    CGFloat s = sqrt(x*x + y*y)/self.maxLength;
    CGFloat t = floor(290*(1 - s)) - 45;
    self.color = [UIColor colorWithHue:t/255.0 saturation:0.5f brightness:0.5f alpha:1.0];
//    [self setNeedsDisplay];
}

-(void)resetWithCenter:(CGPoint)center age:(NSInteger)age xv:(CGFloat)xv yv:(CGFloat)yv
{
    self.age = age;
    [self updateWithCenter:center xv:xv yv:yv];
    
    self.oldCenter = CGPointMake(-1, -1);
}

-(CGFloat)length
{
    if (self.oldCenter.x == -1) {
        return 5;
    }
    return sqrt((self.center.x-self.oldCenter.x)*(self.center.x-self.oldCenter.x) + (self.center.y-self.oldCenter.y)*(self.center.y-self.oldCenter.y));
}

-(CGFloat)angleWithXY
{
//    CGFloat r = sqrt(self.xv*self.xv + self.yv*self.yv);
//    return self.yv/r;
    CGFloat angle = 0;
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
//    return atan2(self.yv, self.xv);
}

-(void)updateWithCenter:(CGPoint)center xv:(CGFloat)xv yv:(CGFloat)yv
{
    self.oldCenter = self.center;
    self.center = center;
    [self setVelocityWithX:xv y:yv];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"center: %@, xv: %.2f, yv: %.2f", [NSValue valueWithCGPoint:self.center], self.xv, self.yv];
}
@end
