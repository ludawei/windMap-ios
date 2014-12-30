//
//  NewMapCoverView.h
//  windMap
//
//  Created by 卢大维 on 14/12/26.
//  Copyright (c) 2014年 weather. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol NewMapCoverViewDelegate <NSObject>

-(CGPoint)viewPointFromMapPoint:(CGPoint)point;
-(CGPoint)mapPointFromViewPoint:(CGPoint)point;

@end

@interface NewMapCoverView : UIView

@property (nonatomic) CLLocationCoordinate2D coor0, coor1;
@property (nonatomic,weak) id<NewMapCoverViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame fields:(NSArray *)fields;
-(void)stop;
-(void)restart;

@end
