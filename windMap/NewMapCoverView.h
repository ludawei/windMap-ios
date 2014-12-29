//
//  NewMapCoverView.h
//  windMap
//
//  Created by 卢大维 on 14/12/26.
//  Copyright (c) 2014年 weather. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMapCoverView : UIView

-(id)initWithFrame:(CGRect)frame fields:(NSArray *)fields;
-(void)stop;
-(void)restart;

@end
