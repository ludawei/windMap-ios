//
//  NewMapCoverView.h
//  windMap
//
//  Created by 卢大维 on 14/12/26.
//  Copyright (c) 2014年 weather. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CWMyMotionStreakView.h"

@interface NewMapCoverView : UIView

@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) CWMyMotionStreakView *motionView;
@property (nonatomic) int particleType;         // 1，箭头；2，线段
@property (nonatomic) NSInteger partNum;

-(id)initWithFrame:(CGRect)frame fields:(NSArray *)fields;
-(void)stop;
-(void)restart;

@end
