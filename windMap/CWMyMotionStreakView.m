//
//  CWMyMotionStreakView.m
//  ChinaWeather
//
//  Created by 卢大维 on 15/1/27.
//  Copyright (c) 2015年 Platomix. All rights reserved.
//

#import "CWMyMotionStreakView.h"

#define LIMIT 20

@interface CWMyMotionStreakView ()

@property (nonatomic,strong) NSMutableArray *imgLayers;

@end

@implementation CWMyMotionStreakView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.imgLayers = [NSMutableArray arrayWithCapacity:LIMIT];
    }
    
    return self;
}

-(void)addImage:(UIImage *)image
{
    if (self.imgLayers.count == LIMIT) {
        CALayer *layer = self.imgLayers.lastObject;
        [layer removeFromSuperlayer];
        [self.imgLayers removeLastObject];
    }
//    [self.imgLayers insertObject:image atIndex:0];
    
    CALayer *layer = [CALayer layer];
    layer.frame = self.bounds;
    layer.contents = (id)image.CGImage;
    [self.layer addSublayer:layer];
    
//    [self drawLayer:layer inContext:CGContextcu]
    
    [self.imgLayers insertObject:layer atIndex:0];
    
    for (NSInteger i=self.imgLayers.count-1; i>=0; i--) {
        CALayer *layer = [self.imgLayers objectAtIndex:i];
        layer.opacity = 1.0f-1.0f*i/self.imgLayers.count;
    }
}

-(void)addLayer:(CALayer *)layer1
{
    if (self.imgLayers.count == LIMIT) {
        CALayer *layer = self.imgLayers.lastObject;
        [layer removeFromSuperlayer];
        [self.imgLayers removeLastObject];
    }
    
    CALayer *layer = [CALayer layer];
    layer.frame = self.bounds;
//    layer.contents = (id)image.CGImage;
    layer.contents = layer1.contents;
    layer.actions = @{@"opacity": [NSNull null]};              // 取消动画
    [self.layer addSublayer:layer];
    
    [self.imgLayers insertObject:layer atIndex:0];
    
    for (NSInteger i=self.imgLayers.count-1; i>=0; i--) {
        CALayer *layer = [self.imgLayers objectAtIndex:i];
        layer.opacity = layer.opacity - 1.0/LIMIT;
    }
}

@end
