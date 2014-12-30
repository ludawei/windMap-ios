//
//  NewMapCoverView.h
//  windMap
//
//  Created by 卢大维 on 14/12/26.
//  Copyright (c) 2014年 weather. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BMapKit.h"

@interface NewMapCoverView : UIView

@property (nonatomic,strong) BMKMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D coor0, coor1;

-(id)initWithFrame:(CGRect)frame fields:(NSArray *)fields;
-(void)stop;
-(void)restart;

@end
