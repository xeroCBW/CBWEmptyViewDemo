//
//  UIView+CBWPlaceHolderView.h
//  CBWEmptyViewDemo
//
//  Created by 陈博文 on 16/8/5.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBWPlaceHolderView.h"

typedef void(^CBWEmptyViewClickBlock)();

@interface UIView (CBWPlaceHolderView)

/** 占位空白页*/
@property (nonatomic ,strong) CBWPlaceHolderView *cbw_placeHolderView;

@end
