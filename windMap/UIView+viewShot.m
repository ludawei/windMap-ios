//
//  UIView+viewShot.m
//  windMap
//
//  Created by 卢大维 on 14/12/30.
//  Copyright (c) 2014年 weather. All rights reserved.
//

#import "UIView+viewShot.h"

@implementation UIView (viewShot)

- (UIImage *)viewShot
{
    CGFloat restoredAlpha = self.alpha;
    
    self.alpha = 1;
    UIImage *image;
    @autoreleasepool {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
        if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [self drawViewHierarchyInRect:self.bounds
                       afterScreenUpdates:NO];
        }
        else
        {
            [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        }
//        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
//        NSLog(@"%@", image);
        
        UIGraphicsEndImageContext();
    }
    
    self.alpha = restoredAlpha;
    
    return image;
}

- (UIImage *)viewShotWithAlpha:(CGFloat)alpha
{
    CGFloat restoredAlpha = self.alpha;
    
    self.alpha = alpha;
    UIImage *image;
    @autoreleasepool {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
//        if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
//            [self drawViewHierarchyInRect:self.bounds
//                       afterScreenUpdates:YES];
//        }
//        else
//        {
//            [self.layer renderInContext:UIGraphicsGetCurrentContext()];
//        }
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    self.alpha = restoredAlpha;
    
    return image;
}

//- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha {
//    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
//    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
//    
//    CGContextScaleCTM(ctx, 1, -1);
//    CGContextTranslateCTM(ctx, 0, -area.size.height);
//    
//    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
//    
//    CGContextSetAlpha(ctx, alpha);
//    
//    CGContextDrawImage(ctx, area, self.CGImage);
//    
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//}

@end
