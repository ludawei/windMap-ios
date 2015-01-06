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

#define PARTICLE_WIDTH 7
#define PARTICLE_HEIGHT 4

#define ARC4RANDOM_MAX      0x100000000
#define PARTICLE_LIMIT      300

#define REFRESH_TIMEVAL     0.04f

@interface NewMapCoverView ()
{
//    BOOL testFlag;
    int imageTimeCount;
}

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic) CGFloat x0,y0,x1,y1;
@property (nonatomic) NSInteger gridWidth,gridHeight;
@property (nonatomic) CGFloat maxLength;
@property (nonatomic,strong) NSArray *fields;

@property (nonatomic,strong) NSMutableArray *particles;

@property (nonatomic,strong) UIBezierPath *arrowPath;

@property (nonatomic,strong) UIImageView *imgView;

@end

@implementation NewMapCoverView

-(id)initWithFrame:(CGRect)frame fields:(NSArray *)fields
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
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
        
        // 用来显示拖尾巴效果
        self.imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imgView.alpha = 0.85;
        [self addSubview:self.imgView];
    }
    
    return self;
}

-(void)setParticleType:(int)particleType
{
    _particleType = particleType;
    if (particleType == 1) {
        self.imgView.hidden = YES;
    }
    else
    {
        self.imgView.hidden = NO;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    CGContextClearRect(context, self.bounds);
    
    if (self.particleType == 2)
    {
        UIImage *image = [self viewShot];
        self.imgView.image = image;
    }
    
    for (int i=0; i<PARTICLE_LIMIT; i++) {
        
        [self drawPathInContext:context particle:[self.particles objectAtIndex:i]];
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
    
    CGFloat temp_alpha = 10.0f;
    CGFloat alpha = particle.age/temp_alpha;
    if (particle.initAge-particle.age <= temp_alpha) {
        alpha = (particle.initAge-particle.age)/temp_alpha;
    }
    CGContextSetAlpha(context, alpha);
    
    if (self.particleType == 1) {
        CGContextTranslateCTM(context, point.x, point.y);       // 移动原点
        CGContextRotateCTM(context, particle.angleWithXY);      // 旋转画布
        CGContextSetFillColorWithColor(context, [particle.color CGColor]);
        [self.arrowPath fill];
    }
    else if (self.particleType == 2)
    {
        /**********************************   画一条线段  *****************************************/
        CGContextSetStrokeColorWithColor(context, [particle.color CGColor]);
        
//        point = CGPointZero;
//        CGPoint newPoint = point;
        
        CGContextSetLineWidth(context, 2);
        
        CGPoint newPoint = CGPointMake(particle.center.x, particle.center.y);
        CGContextMoveToPoint(context, newPoint.x, newPoint.y);
        
        newPoint = CGPointMake(particle.oldCenter.x, particle.oldCenter.y);
        CGContextAddLineToPoint(context, newPoint.x, newPoint.y);
        
        CGContextStrokePath(context);
        /**********************************   画一条线段  *****************************************/
    }
    
    CGContextRestoreGState(context);
}

-(UIBezierPath *)arrowPath
{
    if (!_arrowPath) {
        /**********************************   画一个箭头  *****************************************/
        
        _arrowPath = [UIBezierPath bezierPath];
        
        CGSize size = CGSizeMake(PARTICLE_WIDTH, PARTICLE_HEIGHT);
        
        CGPoint point = CGPointZero;
        
        CGPoint newPoint = CGPointMake((0 + point.x), (size.height*((1-S_HEIGHT_RADIO)/2.0) + point.y));
        [_arrowPath moveToPoint:newPoint];
        
        newPoint = CGPointMake((size.width*S_WIDTH_RADIO + point.x), (size.height*((1-S_HEIGHT_RADIO)/2.0) + point.y));
        [_arrowPath addLineToPoint:newPoint];
        
        newPoint = CGPointMake((size.width*S_WIDTH_RADIO + point.x), (0 + point.y));
        [_arrowPath addLineToPoint:newPoint];
        
        newPoint = CGPointMake((size.width + point.x), (size.height*0.5 + point.y));
        [_arrowPath addLineToPoint:newPoint];
        
        newPoint = CGPointMake((size.width*S_WIDTH_RADIO + point.x), (size.height + point.y));
        [_arrowPath addLineToPoint:newPoint];
        
        newPoint = CGPointMake((size.width*S_WIDTH_RADIO + point.x), (size.height*((1+S_HEIGHT_RADIO)/2.0) + point.y));
        [_arrowPath addLineToPoint:newPoint];
        
        newPoint = CGPointMake((0 + point.x), (size.height*((1+S_HEIGHT_RADIO)/2.0) + point.y));
        [_arrowPath addLineToPoint:newPoint];
         /**********************************   画一个箭头  *****************************************/
    }
    return _arrowPath;
}

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:REFRESH_TIMEVAL target:self selector:@selector(timeFired) userInfo:nil repeats:YES];
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
    return 50+arc4random_uniform(150);
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
    
    NSInteger index = self.gridHeight;
    return [(Vector *)[self.fields objectAtIndex:MIN((na*index+nb), self.fields.count-1)] ValueWithIsX:isX] * (1 - fa) * (1 - fb) +
    [(Vector *)[self.fields objectAtIndex:MIN((ma*index+nb), self.fields.count-1)] ValueWithIsX:isX] * fa * (1 - fb) +
    [(Vector *)[self.fields objectAtIndex:MIN((na*index+mb), self.fields.count-1)] ValueWithIsX:isX] * (1 - fa) * fb +
    [(Vector *)[self.fields objectAtIndex:MIN((ma*index+mb), self.fields.count-1)] ValueWithIsX:isX] * fa * fb;
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

//        __weak typeof(self) weakSelf = self;
        [self.particles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WindParticle *particle = (WindParticle *)obj;
            [self updateCenter:particle];
            
            if (idx == self.particles.count-1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setNeedsDisplay];
                });
            }
        }];
    });
}

-(void)updateCenter:(WindParticle *)particle
{
    particle.age--;
    if (particle.age <= 0) {
        CGPoint center = [self randomParticleCenter];
        Vector *vect = [self vecorWithPoint:[self mapPointFromViewPoint:center]];
        [particle resetWithCenter:center age:[self randomAge] xv:vect.x yv:vect.y colorBright:self.mapView.mapType==BMKMapTypeSatellite];
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
            [particle resetWithCenter:center age:[self randomAge] xv:vect.x yv:vect.y colorBright:self.mapView.mapType==BMKMapTypeSatellite];
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
    if (self.mapView) {
        CLLocationCoordinate2D coor = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        
        return CGPointMake(coor.longitude, coor.latitude);
    }
    
    return point;
}

@end
