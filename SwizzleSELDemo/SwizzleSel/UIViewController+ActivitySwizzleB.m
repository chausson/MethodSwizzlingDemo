//
//  UIViewController+ActivitySwizzleB.m
//  SwizzleSELDemo
//
//  Created by Chausson on 16/8/1.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import "UIViewController+ActivitySwizzleB.h"
#import <objc/runtime.h>
@implementation UIViewController (ActivitySwizzleB)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self installB];
    });
}
+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSEL,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}
- (void)ch_ActivitySwizzleB_ViewDidLoad{
    NSLog(@"B---ActivitySwizzleB");
    [self ch_ActivitySwizzleB_ViewDidLoad];
}
+ (void)installB{
      [self swizzleSEL:@selector(viewDidLoad) withSEL:@selector(ch_ActivitySwizzleB_ViewDidLoad)];
}
@end
