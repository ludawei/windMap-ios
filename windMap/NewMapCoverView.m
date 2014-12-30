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
#import "UIView+viewShot.h"

#define S_HEIGHT_RADIO 0.5
#define S_WIDTH_RADIO 0.6

#define PARTICLE_WIDTH 10
#define PARTICLE_HEIGHT 6

#define ARC4RANDOM_MAX      0x100000000
#define PARTICLE_LIMIT      500

@interface NewMapCoverView ()
{
//    BOOL testFlag;
}

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic) CGFloat x0,y0,x1,y1;
@property (nonatomic) NSInteger gridWidth,gridHeight;
@property (nonatomic) CGFloat maxLength;
@property (nonatomic,strong) NSArray *fields;

@property (nonatomic,strong) NSMutableArray *particles;

//@property (nonatomic,strong) UIImage *lastViewShot;

@end

@implementation NewMapCoverView

-(id)initWithFrame:(CGRect)frame fields:(NSArray *)fields
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
//        self.opaque = NO;
//        self.clearsContextBeforeDrawing = NO;
//        self.alpha = 0.8;
        
        self.particles = [NSMutableArray arrayWithCapacity:PARTICLE_LIMIT];
        self.x0 = -178.875;
        self.y0 = -90.0;
        self.x1 = 180;
        self.y1 = 90;
        self.gridWidth = 320;
        self.gridHeight = 161;
        
        [self setupFields:fields];
        
        for (int i = 0; i<PARTICLE_LIMIT; i++) {
            WindParticle *particle = [[WindParticle alloc] init];
            particle.maxLength = self.maxLength;
            
//            CGPoint center = [self randomParticleCenter];//CGPointMake(MIN(self.bounds.size.width, i), i);//
//            Vector *vect = [self vecorWithPoint:center];
//            [particle resetWithCenter:center age:[self randomAge] xv:vect.x yv:vect.y];
            
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
#if 1
    for (int i=0; i<PARTICLE_LIMIT; i++) {

        [self drawPathInContext:context particle:[self.particles objectAtIndex:i]];
//        [self drawPathWithCenter:center ctx:context];
    }
#else
    CGContextSaveGState(context);
//    CGContextSetAlpha(context, 0.8);
    
    @autoreleasepool {
        UIImage *image = [self viewShotWithAlpha:0.8];
        if (image) {
            [image drawAtPoint:CGPointZero];
            image = nil;
        }
    }
    
    CGContextRestoreGState(context);
    
    for (int i=0; i<PARTICLE_LIMIT; i++) {
        
        [self drawPathInContext1:context particle:[self.particles objectAtIndex:i]];
    }
#endif
    UIGraphicsPopContext();
//    CGContextRelease(context);
}

-(void)drawPathInContext1:(CGContextRef)context particle:(WindParticle *)particle
{
    if (particle.age <= 0) {
        return;
    }
    
    CGSize size = CGSizeMake(PARTICLE_WIDTH, PARTICLE_HEIGHT);
    CGPoint center = particle.center;
    CGPoint point = CGPointMake(center.x - size.width/2.0, center.y - size.height/2.0);
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, point.x, point.y);       // 移动原点
    CGContextRotateCTM(context, particle.angleWithXY);      // 旋转画布
    
    //    NSLog(@"start : %@", [NSValue valueWithCGPoint:point]);
    
    /**********************************   画一条线段  *****************************************/
    point = CGPointZero;
    CGPoint newPoint = point;
    CGContextSetStrokeColorWithColor(context, particle.color.CGColor);
    
    CGContextSetLineWidth(context, 2);
    
    newPoint = CGPointMake((0 + point.x), point.y);
    CGContextMoveToPoint(context, newPoint.x, newPoint.y);
    
    newPoint = CGPointMake((particle.length + point.x), point.y);
    CGContextAddLineToPoint(context, newPoint.x, newPoint.y);
    
    CGContextStrokePath(context);
    /**********************************   画一条线段  *****************************************/
    
    CGContextRestoreGState(context);
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
    CGContextTranslateCTM(context, point.x, point.y);       // 移动原点
    CGContextRotateCTM(context, particle.angleWithXY);      // 旋转画布
    
//    NSLog(@"start : %@", [NSValue valueWithCGPoint:point]);
    
    /**********************************   画一个箭头  *****************************************/
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
    /**********************************   画一个箭头  *****************************************/
    
    CGContextRestoreGState(context);
}

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.15f target:self selector:@selector(timeFired) userInfo:nil repeats:YES];
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


// 在界面上随机产生一个点
-(CGPoint)randomParticleCenter
{
    CGFloat x,y;
    double a = ((double)arc4random() / ARC4RANDOM_MAX);
    double b = ((double)arc4random() / ARC4RANDOM_MAX);
#if 0
    x = a*self.x0 + (1-a)*self.x1;
    y = b*self.y0 + (1-b)*self.y1;
#else
    x = (1-a)*self.bounds.size.width;
    y = (1-b)*self.bounds.size.height;
#endif
    return CGPointMake(x, y);
}

// 产生一个随机的生命周期
-(NSInteger)randomAge
{
    return 1+arc4random_uniform(40);
}



/**
 *  根据周围点的速度，得到该点的速度
 *
 *  @param isX 是X，还是Y
 *  @param a   x方向上的值
 *  @param b   y方向上的值
 *
 *  @return 得到该点的速度（x或y）
 */
-(CGFloat)bilinearWithIsX:(BOOL)isX a:(CGFloat)a b:(CGFloat)b
{
    NSInteger na = MIN((int)floor(a), self.gridWidth-1);
    NSInteger nb = MIN((int)floor(b), self.gridHeight-1);
    NSInteger ma = MIN((int)ceil(a), self.gridWidth-1);
    NSInteger mb = MIN((int)ceil(b), self.gridHeight-1);
    CGFloat fa = a - na;
    CGFloat fb = b - nb;
    
    NSInteger index = self.gridHeight;//isX?self.gridHeight:self.gridWidth;
    return [(Vector *)[self.fields objectAtIndex:MIN((na*index+nb), self.fields.count-1)] ValueWithIsX:isX] * (1 - fa) * (1 - fb) +
    [(Vector *)[self.fields objectAtIndex:MIN((ma*index+nb), self.fields.count-1)] ValueWithIsX:isX] * fa * (1 - fb) +
    [(Vector *)[self.fields objectAtIndex:MIN((na*index+mb), self.fields.count-1)] ValueWithIsX:isX] * (1 - fa) * fb +
    [(Vector *)[self.fields objectAtIndex:MIN((ma*index+mb), self.fields.count-1)] ValueWithIsX:isX] * fa * fb;
//    return [(Vector *)self.fields[na][nb] ValueWithIsX:isX] * (1 - fa) * (1 - fb) +
//    [(Vector *)self.fields[ma][nb] ValueWithIsX:isX] * fa * (1 - fb) +
//    [(Vector *)self.fields[na][mb] ValueWithIsX:isX] * (1 - fa) * fb +
//    [(Vector *)self.fields[ma][mb] ValueWithIsX:isX] * fa * fb;
}

/**
 *  根据任一经纬度，得到一个速度Vector
 *
 *  @param point 经纬度(x为long, y为lat)
 *
 *  @return 得到一个速度Vector
 */
-(Vector *)vecorWithPoint:(CGPoint)point
{
//    point = CGPointMake(-178.875,-90);
    CGFloat a = (self.gridWidth - 1 - 1e-6)*(point.x - self.x0)/(self.x1 - self.x0);
    CGFloat b = (self.gridHeight - 1 - 1e-6)*(point.y - self.y0)/(self.y1 - self.y0);
    CGFloat vx = [self bilinearWithIsX:YES a:a b:b];
    CGFloat vy = [self bilinearWithIsX:NO a:a b:b];
    
//    NSLog(@"vx: %f, vy: %f", vx, vy);
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
    particle.age--;
    if (particle.age <= 0) {
        CGPoint center = [self randomParticleCenter];
        Vector *vect = [self vecorWithPoint:[self mapPointFromViewPoint:center]];
        [particle resetWithCenter:center age:[self randomAge] xv:vect.x yv:vect.y];
    }
    else
    {
        // 经度自下向上，画布自上向下，故取反
        CGPoint center = CGPointMake(particle.center.x+particle.xv, particle.center.y+(-particle.yv));
        CGRect disRect = self.bounds;
        CGRect disMapRect = CGRectMake(self.x0, self.y0, self.x1-self.x0, self.y1-self.y0);
        
        CGPoint mapPoint = [self mapPointFromViewPoint:center];
        if (!CGRectContainsPoint(disRect, center) || !CGRectContainsPoint(disMapRect, mapPoint)) {
            center = [self randomParticleCenter];
            Vector *vect = [self vecorWithPoint:[self mapPointFromViewPoint:center]];
            [particle resetWithCenter:center age:[self randomAge] xv:vect.x yv:vect.y];
        }
        
        Vector *vect = [self vecorWithPoint:mapPoint];
        [particle updateWithCenter:center xv:vect.x yv:vect.y];
    }
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

// 返回view上的点对应在地图上的位置
-(CGPoint)mapPointFromViewPoint:(CGPoint)point
{
    //    CLLocationCoordinate2D coor1 = CLLocationCoordinate2DMake(self.mapView.region.center.latitude - self.mapView.region.span.latitudeDelta/2, self.mapView.region.center.longitude - self.mapView.region.span.longitudeDelta/2);
    //    CLLocationCoordinate2D coor2 = CLLocationCoordinate2DMake(self.mapView.region.center.latitude + self.mapView.region.span.latitudeDelta/2, self.mapView.region.center.longitude + self.mapView.region.span.longitudeDelta/2);
    if (self.mapView) {
        CLLocationCoordinate2D coor = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        
        return CGPointMake(coor.longitude, coor.latitude);
    }
    
    return point;
    
    //    CGPoint point1 = CGPointMake(MAX(MIN(coor.longitude, coor2.longitude), coor1.longitude), MAX(MIN(coor.latitude, coor2.latitude), coor1.latitude));
    
}
@end
