//
//  CWMyMotionStreakView.m
//  ChinaWeather
//
//  Created by 卢大维 on 15/1/27.
//  Copyright (c) 2015年 Platomix. All rights reserved.
//

#import "CWMyMotionStreakView.h"

#define LIMIT 30

@interface CWMyMotionStreakView ()

@property (nonatomic,strong) NSMutableArray *imgLayers;

@end

@implementation CWMyMotionStreakView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.imgLayers = [NSMutableArray arrayWithCapacity:LIMIT];
    }
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    
    for (NSInteger i=self.imgLayers.count-1; i>=0; i--) {
        
        CGContextSaveGState(context);
        CGContextSetAlpha(context, 1.0f-1.0f*i/self.imgLayers.count);
        CGContextDrawImage(context, self.bounds, [self.imgLayers[i] CGImage]);
        CGContextRestoreGState(context);
    }
}

-(void)addImage:(UIImage *)image
{
    if (self.imgLayers.count == LIMIT) {
        [self.imgLayers removeLastObject];
    }
    [self.imgLayers insertObject:image atIndex:0];
    
    [self setNeedsDisplay];
}
@end
