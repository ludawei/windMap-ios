//
//  Vector.m
//  windMap
//
//  Created by 卢大维 on 14/12/25.
//  Copyright (c) 2014年 weather. All rights reserved.
//

#import "Vector.h"

@implementation Vector

-(CGFloat)ValueWithIsX:(BOOL)isX
{
    if (isX) {
        return self.x;
    }
    else
    {
        return self.y;
    }
}

-(CGFloat)length
{
    return sqrt(self.x*self.x + self.y*self.y);
}
@end
