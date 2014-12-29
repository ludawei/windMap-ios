//
//  ViewController.m
//  windMap
//
//  Created by 卢大维 on 14/12/25.
//  Copyright (c) 2014年 weather. All rights reserved.
//

#import "ViewController.h"
#import "MapCoverView.h"
#import "Masonry.h"
#import "BMapKit.h"
#import "NewMapCoverView.h"
#import "TestView.h"

@interface ViewController ()<BMKMapViewDelegate, NewMapCoverViewDelegate>

@property (nonatomic,strong) NewMapCoverView *mainView;
@property (nonatomic,strong) BMKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    [self initMapView];
    
#if 1
    NSString *data = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"data" withExtension:nil] encoding:NSUTF8StringEncoding error:nil];
    NSArray *fields = [data componentsSeparatedByString:@",\n"];
    
    
    self.mainView = [[NewMapCoverView alloc] initWithFrame:self.view.bounds fields:fields];
    self.mainView.delegate = self;
    self.mainView.userInteractionEnabled = NO;
    self.mainView.translatesAutoresizingMaskIntoConstraints = YES;
    self.mainView.frame = self.view.bounds;
    
    [self.view addSubview:self.mainView];
#else
    TestView *view = [[TestView alloc] initWithFrame:self.view.bounds];
    view.translatesAutoresizingMaskIntoConstraints = YES;
    view.frame = self.view.bounds;
    
    [self.view addSubview:view];
#endif
}

-(void)initMapView
{
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.mapView.scrollEnabled = YES;
    [self.view addSubview:self.mapView];
}

- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    [self.mainView stop];
}

-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocationCoordinate2D coor1 = CLLocationCoordinate2DMake(mapView.region.center.latitude + mapView.region.span.latitudeDelta/2, mapView.region.center.longitude - mapView.region.span.longitudeDelta/2);
    CLLocationCoordinate2D coor2 = CLLocationCoordinate2DMake(mapView.region.center.latitude - mapView.region.span.latitudeDelta/2, mapView.region.center.longitude + mapView.region.span.longitudeDelta/2);
    
//    CGPoint point1 = [self.mapView convertCoordinate:coor1 toPointToView:self.mapView];
//    CGPoint point2 = [self.mapView convertCoordinate:coor2 toPointToView:self.mapView];
//    NSLog(@"%@, %@", [NSValue valueWithCGPoint:point1], [NSValue valueWithCGPoint:point2]);
    
    [self.mainView restartWithNewPoint1:CGPointMake(coor1.longitude, coor1.latitude) point2:CGPointMake(coor2.longitude, coor2.latitude)];
}

-(CGPoint)viewPointFromMapPoint:(CGPoint)point
{
    CGPoint point1 = [self.mapView convertCoordinate:CLLocationCoordinate2DMake(point.y, point.x) toPointToView:self.mapView];
    return point1;
}

-(CGPoint)mapPointFromViewPoint:(CGPoint)point
{
    CLLocationCoordinate2D coor = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    return CGPointMake(coor.longitude, coor.latitude);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
