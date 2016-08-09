//
//  UIView+CBWPlaceHolderView.m
//  CBWEmptyViewDemo
//
//  Created by 陈博文 on 16/8/5.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import "UIView+CBWPlaceHolderView.h"

#import <objc/runtime.h>
#import <objc/message.h>

static const char CBWPlacHolederViewKey = '\1';


@implementation UIView (CBWPlaceHolderView)


-(UIView *)cbw_placeHolderView{
    
    return objc_getAssociatedObject(self, &CBWPlacHolederViewKey);
}

-(void)setCbw_placeHolderView:(CBWPlaceHolderView *)cbw_placeHolderView{
    
        if (cbw_placeHolderView != self.cbw_placeHolderView) {
            // 删除旧的，添加新的
            [self.cbw_placeHolderView removeFromSuperview];
            [self insertSubview:cbw_placeHolderView atIndex:0];
            
            // 存储新的
            [self willChangeValueForKey:@"cbw_placeHolderView"]; // KVO
            
            objc_setAssociatedObject(self, &CBWPlacHolederViewKey,
                                     cbw_placeHolderView,
                                     OBJC_ASSOCIATION_ASSIGN);
            
            [self didChangeValueForKey:@"cbw_placeHolderView"]; // KVO
        }

}


@end
