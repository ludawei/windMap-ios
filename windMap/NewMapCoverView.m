//
//  NewMapCoverView.m
//  windMap
//
//  Created by 卢大维 on 14/12/26.
//  Copyright (c) 2014年 weather. All rights reserved.
//

#import "NewMapCoverView.h"
#import "Vector.h"
#import "WindParticle.h"

#define S_HEIGHT_RADIO 0.5
#define S_WIDTH_RADIO 0.6

#define PARTICLE_WIDTH 10
#define PARTICLE_HEIGHT 6

#define ARC4RANDOM_MAX      0x100000000
#define PARTICLE_LIMIT      500

@interface NewMapCoverView ()

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic) CGFloat x0,y0,x1,y1;
@property (nonatomic) NSInteger gridWidth,gridHeight;
@property (nonatomic) CGFloat maxLength;
@property (nonatomic,strong) NSArray *fields;

@property (nonatomic,strong) NSMutableArray *particles;

@end

@implementation NewMapCoverView

-(id)initWithFrame:(CGRect)frame fields:(NSArray *)fields
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.particles = [NSMutableArray arrayWithCapacity:PARTICLE_LIMIT];
        self.x0 = -178.875;
        self.y0 = -90.0;
        self.x1 = 180;
        self.y1 = 90;
        self.gridWidth = 320;
        self.gridHeight = 161;
        
        self.x0 = 0;
        self.y0 = 0;
        self.x1 = self.bounds.size.width;
        self.y1 = self.bounds.size.height;
        
        [self setupFields:fields];
        
        for (int i = 0; i<PARTICLE_LIMIT; i++) {
            WindParticle *particle = [[WindParticle alloc] init];
            particle.maxLength = self.maxLength;
            
            CGPoint center = [self randomParticleCenter];//CGPointMake(MIN(self.bounds.size.width, i), i);//
            Vector *vect = [self vecorWithPoint:center];
            [particle resetWithCenter:center age:[self randomAge] xv:vect.x yv:vect.y];
            
            [self.particles addObject:particle];
        }
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    CGContextClearRect(context, self.bounds);
    
    for (int i=0; i<PARTICLE_LIMIT; i++) {

        [self drawPathInContext:context particle:[self.particles objectAtIndex:i]];
//        [self drawPathWithCenter:center ctx:context];
    }
    UIGraphicsPopContext();
}

-(void)drawPathInContext:(CGContextRef)context particle:(WindParticle *)particle
{
    if (particle.age <= 0) {
        return;
    }
    
    CGSize size = CGSizeMake(PARTICLE_WIDTH, PARTICLE_HEIGHT);
    CGPoint center = particle.center;
    CGPoint point = CGPointMake(center.x - size.width/2.0, center.y - size.height/2.0);

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, point.x, point.y);
    CGContextRotateCTM(context, particle.angleWithXY);
    
//    NSLog(@"start : %@", [NSValue valueWithCGPoint:point]);
    
    point = CGPointZero;
    CGPoint newPoint = point;
    CGContextSetFillColorWithColor(context, particle.color.CGColor);
    
    newPoint = CGPointMake((0 + point.x), (size.height*((1-S_HEIGHT_RADIO)/2.0) + point.y));
    CGContextMoveToPoint(context, newPoint.x, newPoint.y);
    
    newPoint = CGPointMake((size.width*S_WIDTH_RADIO + point.x), (size.height*((1-S_HEIGHT_RADIO)/2.0) + point.y));
    CGContextAddLineToPoint(context, newPoint.x, newPoint.y);
    
    newPoint = CGPointMake((size.width*S_WIDTH_RADIO + point.x), (0 + point.y));
    CGContextAddLineToPoint(context, newPoint.x, newPoint.y);
    
    newPoint = CGPointMake((size.width + point.x), (size.height*0.5 + point.y));
    CGContextAddLineToPoint(context, newPoint.x, newPoint.y);
    
    newPoint = CGPointMake((size.width*S_WIDTH_RADIO + point.x), (size.height + point.y));
    CGContextAddLineToPoint(context, newPoint.x, newPoint.y);
    
    newPoint = CGPointMake((size.width*S_WIDTH_RADIO + point.x), (size.height*((1+S_HEIGHT_RADIO)/2.0) + point.y));
    CGContextAddLineToPoint(context, newPoint.x, newPoint.y);
    
    newPoint = CGPointMake((0 + point.x), (size.height*((1+S_HEIGHT_RADIO)/2.0) + point.y));
    CGContextAddLineToPoint(context, newPoint.x, newPoint.y);
    
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
}

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timeFired) userInfo:nil repeats:YES];
}

-(void)setupFields:(NSArray *)fields
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:fields.count];
    [fields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *str = (NSString *)obj;
        if (str) {
            NSArray *vs = [str componentsSeparatedByString:@","];
            if (vs.count == 2) {
                Vector *v = [Vector new];
                v.x = [vs.firstObject floatValue];
                v.y = [vs.lastObject floatValue];
                
                [arr addObject:v];
                
                self.maxLength = MAX(self.maxLength, [v length]);
            }
        }
    }];
    
    self.fields = arr;
}

-(CGPoint)randomParticleCenter
{
    CGFloat x,y;
    double a = ((double)arc4random() / ARC4RANDOM_MAX);
    double b = ((double)arc4random() / ARC4RANDOM_MAX);
    x = a*self.x0 + (1-a)*self.x1;
    y = b*self.y0 + (1-b)*self.y1;
    return CGPointMake(x, y);
}

-(NSInteger)randomAge
{
    return 1+arc4random_uniform(40);
}

-(CGFloat)bilinearWithIsX:(BOOL)isX a:(CGFloat)a b:(CGFloat)b
{
    NSInteger na = (int)floor(a);
    NSInteger nb = (int)floor(b);
    NSInteger ma = (int)ceil(a);
    NSInteger mb = (int)ceil(b);
    NSInteger fa = a - na;
    NSInteger fb = b - nb;
    
    NSInteger index = self.gridHeight;//isX?self.gridHeight:self.gridWidth;
    return [(Vector *)[self.fields objectAtIndex:MIN((na*index+nb), self.fields.count-1)] ValueWithIsX:isX] * (1 - fa) * (1 - fb) +
    [(Vector *)[self.fields objectAtIndex:MIN((ma*index+nb), self.fields.count-1)] ValueWithIsX:isX] * fa * (1 - fb) +
    [(Vector *)[self.fields objectAtIndex:MIN((na*index+mb), self.fields.count-1)] ValueWithIsX:isX] * (1 - fa) * fb +
    [(Vector *)[self.fields objectAtIndex:MIN((ma*index+mb), self.fields.count-1)] ValueWithIsX:isX] * fa * fb;
}

-(Vector *)vecorWithPoint:(CGPoint)point
{
    CGFloat a = (self.gridWidth - 1 - 1e-6)*(point.x - self.x0)/(self.x1 - self.x0);
    CGFloat b = (self.gridHeight - 1 - 1e-6)*(point.y - self.y0)/(self.y1 - self.y0);
    CGFloat vx = [self bilinearWithIsX:YES a:a b:b];
    CGFloat vy = [self bilinearWithIsX:NO a:a b:b];
    
    Vector *v = [Vector new];
    v.x = vx;
    v.y = vy;
    
    return v;
}

-(void)timeFired
{
    [self.particles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        WindParticle *particle = (WindParticle *)obj;
        [self updateCenter:particle];
    }];
    [self setNeedsDisplay];
}

-(void)updateCenter:(WindParticle *)particle
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        particle.age--;
        if (particle.age <= 0) {
            CGPoint center = [self randomParticleCenter];
            Vector *vect = [self vecorWithPoint:center];
//            dispatch_async(dispatch_get_main_queue(), ^{
                [particle resetWithCenter:center age:[self randomAge] xv:vect.x yv:vect.y];
//            });
        }
        else
        {
            CGPoint center = CGPointMake(particle.center.x+particle.xv, particle.center.y+particle.yv);
            CGRect disRect = CGRectMake(self.x0, self.y0, self.x1-self.x0, self.y1-self.y0);
            if (!CGRectContainsPoint(disRect, center)) {
                center = [self randomParticleCenter];
                Vector *vect = [self vecorWithPoint:center];
//                dispatch_async(dispatch_get_main_queue(), ^{
                    [particle resetWithCenter:center age:[self randomAge] xv:vect.x yv:vect.y];
//                });
            }
            
            Vector *vect = [self vecorWithPoint:center];
//            dispatch_async(dispatch_get_main_queue(), ^{
                [particle updateWithCenter:center xv:vect.x yv:vect.y];
//            });
        }
//    });
    
}

-(void)stop
{
    [self.timer setFireDate:[NSDate distantFuture]];
    self.hidden = YES;
}

-(void)restart
{
    [self.timer setFireDate:[NSDate distantPast]];
    self.hidden = NO;
}

@end
