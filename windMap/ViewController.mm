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

@interface ViewController ()<BMKMapViewDelegate>

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
    [self.mainView restart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
