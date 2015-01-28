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
#import "NewMapCoverView.h"
#import <MapKit/MapKit.h>

@interface ViewController ()<MKMapViewDelegate>

@property (nonatomic,strong) NewMapCoverView *mainView;
@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) UISegmentedControl *buttons,*buttons1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    [self initMapView];
    
    NSString *data = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"data" withExtension:nil] encoding:NSUTF8StringEncoding error:nil];
    NSArray *fields = [data componentsSeparatedByString:@",\n"];
    
    
    self.mainView = [[NewMapCoverView alloc] initWithFrame:self.view.bounds fields:fields];
    self.mainView.mapView = self.mapView;
    self.mainView.particleType = 2;
    self.mainView.userInteractionEnabled = NO;
    self.mainView.translatesAutoresizingMaskIntoConstraints = YES;
    self.mainView.frame = self.view.bounds;
    
    [self.view addSubview:self.mainView];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    // 注册
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initMapView
{
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.mapView.scrollEnabled = YES;
    self.mapView.rotateEnabled = NO;
    self.mapView.mapType = MKMapTypeSatellite;
//    self.mapView.overlookEnabled = NO;
//    self.mapView.zoomLevel = 4.5;
    
    self.mapView.alpha = 0.5;
    [self.view addSubview:self.mapView];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    
    UISegmentedControl *buttons = [[UISegmentedControl alloc] initWithItems:@[@"箭头", @"线段"]];
    [self.view addSubview:buttons];
    
    [buttons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-10);
        make.bottom.mas_equalTo(self.view).offset(-10);
        make.size.mas_equalTo(CGSizeMake(100, 32));
    }];
    
    buttons.selectedSegmentIndex = 0;
    [buttons addTarget:self action:@selector(clickButtons:) forControlEvents:UIControlEventValueChanged];
    self.buttons = buttons;
    
    UISegmentedControl *buttons1 = [[UISegmentedControl alloc] initWithItems:@[@"标准", @"卫星"]];
    [self.view addSubview:buttons1];
    
    [buttons1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(10);
        make.bottom.mas_equalTo(self.view).offset(-10);
        make.size.mas_equalTo(CGSizeMake(100, 32));
    }];
    
    buttons1.selectedSegmentIndex = 0;
    [buttons1 addTarget:self action:@selector(clickButtons1:) forControlEvents:UIControlEventValueChanged];
    self.buttons1 = buttons1;
}

-(void)clickButtons:(UISegmentedControl *)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    if (self.mainView.particleType != (int)index + 1) {
        self.mainView.particleType = (int)index + 1;
    }
}

-(void)clickButtons1:(UISegmentedControl *)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    if (self.mapView.mapType != (int)index + 1) {
//        self.mapView.mapType = (int)index + 1;
        
        if (index == 1) {
            self.buttons.tintColor = self.buttons1.tintColor = [UIColor colorWithWhite:1 alpha:1.0];
        }
        else
        {
            self.buttons.tintColor = self.buttons1.tintColor = nil;
        }
    }
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    [self.mainView stop];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
//    CLLocationCoordinate2D coor1 = CLLocationCoordinate2DMake(mapView.region.center.latitude - mapView.region.span.latitudeDelta/2, mapView.region.center.longitude - mapView.region.span.longitudeDelta/2);
//    CLLocationCoordinate2D coor2 = CLLocationCoordinate2DMake(mapView.region.center.latitude + mapView.region.span.latitudeDelta/2, mapView.region.center.longitude + mapView.region.span.longitudeDelta/2);
//
//    NSLog(@"%f, %f, %f, %f", coor1.latitude, coor1.longitude, coor2.latitude, coor2.longitude);
//    CGPoint point1 = [self.mapView convertCoordinate:coor1 toPointToView:self.mapView];
//    CGPoint point2 = [self.mapView convertCoordinate:coor2 toPointToView:self.mapView];
//    NSLog(@"%@, %@", [NSValue valueWithCGPoint:point1], [NSValue valueWithCGPoint:point2]);
//    CGRect rect = [self.mapView convertMapRect:self.mapView.visibleMapRect toRectToView:self.mapView];
//    NSLog(@"%@", [NSValue valueWithCGRect:rect]);
    
    [self.mainView restart];
}

-(void)willEnterForeground
{
    [self.mainView restart];
}

-(void)didEnterBackground
{
    [self.mainView stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
