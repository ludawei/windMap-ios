//
//  Vector.m
//  windMap
//
//  Created by 卢大维 on 14/12/25.
//  Copyright (c) 2014年 weather. All rights reserved.
//

#import "MyVector.h"

@implementation MyVector

+(CGFloat)ValueWithIsX:(BOOL)isX v:(CGVector)v
{
    if (isX) {
        return v.dx;
    }
    else
    {
        return v.dy;
    }
}

+(CGFloat)length:(CGVector)v
{
    return sqrt(v.dx*v.dx + v.dy*v.dy);
}
@end
