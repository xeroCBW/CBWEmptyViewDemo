//
//  CBWPlaceHolderView.h
//  CBWEmptyViewDemo
//
//  Created by 陈博文 on 16/8/5.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CBWPlaceHolderViewType){
    
    CBWPlaceHolderViewTypeLoading = 0,//加载中
    CBWPlaceHolderViewTypeNomoredata,//暂无数据
    CBWPlaceHolderViewTypeNetworkError,//网络异常
};

@interface CBWPlaceHolderView : UIView

+ (instancetype)showEmptyViewWithType:(CBWPlaceHolderViewType)type inParentView:(UIView *)parentView;

/**
 *  创建点击界面不会动作的 HUD
 *
 *  @param message    HUD 的文字说明
 *  @param parentView 需要传进来父类View
 *
 *  @return 创建的 HUD
 */
+ (instancetype)showEmptyViewWithMessage:(NSString *)message inparentView:(UIView *)parentView;

/**
 *  创建点击界面会动作的 HUD
 *
 *  @param message    HUD 的文字说明
 *  @param parentView 需要传进来父类View
 *  @param target     传进来的父类
 *  @param action     传进来的动作
 *
 *  @return 创建的 HUD
 */
+ (instancetype)showEmptyViewWithMessage:(NSString *)message inparentView:(UIView *)parentView target:(id)target action:(SEL)action;

- (void)addButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

- (void)dismiss;


#pragma mark - property

/** messageTextColor*/
@property (nonatomic ,strong) UIColor *messageTextColor;
/** messageFont*/
@property (nonatomic ,strong) UIFont *messageFont;

/** buttonBackgroundColor*/
@property (nonatomic ,strong) UIColor *buttonBackgroundColor;
/** buttonTitleColor*/
@property (nonatomic ,strong) UIColor *buttonTitleColor;
/** buttonTitleFont*/
@property (nonatomic ,strong) UIFont *buttonTitleFont;

/** 默认图片*/
@property (nonatomic,strong) UIImage  *customImage;

/** 设置 gif 动画 */
@property (nonatomic) NSData  *gifImageData;

/** 设置帧动画 */
@property (nonatomic,strong) NSArray  *customAnimationImages;

/** 按钮标题-如果设置 buttonTitle 就会显示 button, 默认是没有显示的*/
@property (nonatomic ,strong) NSString *buttonTiltle;
/** 设置点击 block */
@property (nonatomic,copy)  void(^ButtonClickedBlock)();

/** 回调对象 */
@property (weak, nonatomic) id buttonTarget;//这个一定要使用 weak, 否者会内存泄露
/** 回调方法 */
@property (assign, nonatomic) SEL buttonAction;
@end
