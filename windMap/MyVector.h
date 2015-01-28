//
//  Vector.h
//  windMap
//
//  Created by 卢大维 on 14/12/25.
//  Copyright (c) 2014年 weather. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyVector : NSObject

+(CGFloat)ValueWithIsX:(BOOL)isX v:(CGVector)v;
+(CGFloat)length:(CGVector)v;

@end
