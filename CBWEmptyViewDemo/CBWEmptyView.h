//
//  CBWEmptyView.h
//  CBWEmptyViewDemo
//
//  Created by 陈博文 on 16/8/3.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CBWEmptyViewTypeLoading = 1,//加载中
    CBWEmptyViewTypeFail,//失败
    CBWEmptyViewTypeNomoredata,//没有更多数据
    CBWEmptyViewTypeNetworkError,//网络异常
} CBWEmptyViewType;

typedef void(^CBWEmptyViewClickBlock)();

@interface CBWEmptyView : UIView


+ (void)showEmptyViewWithMessage:(NSString *)message Type:(CBWEmptyViewType)type inparentView:(UIView *)parentView;

+ (void)showEmptyViewWithMessage:(NSString *)message Type:(CBWEmptyViewType)type inparentView:(UIView *)parentView clickBlock:(CBWEmptyViewClickBlock )clickBlock;

+ (void)showEmptyViewWithMessage:(NSString *)message Type:(CBWEmptyViewType)type inparentView:(UIView *)parentView target:(id)target refreshingAction:(SEL)action;
/**
 *  让遮盖消失
 */
+ (void)dismiss;

/** 点击事件的 block*/
@property (nonatomic ,strong) CBWEmptyViewClickBlock clickBlock;



@end
