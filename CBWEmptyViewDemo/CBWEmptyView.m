//
//  CBWEmptyView.m
//  CBWEmptyViewDemo
//
//  Created by 陈博文 on 16/8/3.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import "CBWEmptyView.h"
#import <objc/runtime.h>
#import <objc/message.h>

static const char CBWEmptyViewKey = '\0';

#define kCBWOBJCSetObject(object,value)  objc_setAssociatedObject(object,&CBWEmptyViewKey, value, OBJC_ASSOCIATION_ASSIGN)
#define kCBWOBJCGetObject(object) objc_getAssociatedObject(object,&CBWEmptyViewKey)


// 运行时objc_msgSend
#define CBWEmptyViewMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define CBWEmptyViewMsgTarget(target) (__bridge void *)(target)

static CGFloat kCBWEmptyVieMargin = 10.0;
static CGFloat kCBWEmptyVieMessageLabelWidth = 250.0;
static CGFloat kCBWEmptyVieImageViewWH = 80.0;


@interface CBWEmptyView ()

/** contentView*/
@property (nonatomic ,strong) UIView *contentView;

/** label*/
@property (nonatomic ,strong) UILabel *messageLabel;

/** imageView*/
@property (nonatomic ,strong) UIImageView *imageView;

/** parentView*/
@property (nonatomic ,weak) UIView *parentView;

/** 回调对象 */
@property (weak, nonatomic) id target;
/** 回调方法 */
@property (assign, nonatomic) SEL action;


@end

@implementation CBWEmptyView


- (void)dealloc
{
    NSLog(@"%s",__func__);
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor yellowColor];
        
        [self setUpSubView];
        
    }
    return self;
}



- (void)setUpSubView{
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.messageLabel];
    
    [self addSubview:self.contentView];
    
}



+ (void)showEmptyViewWithMessage:(NSString *)message Type:(CBWEmptyViewType)type inparentView:(UIView *)parentView{
    
    
    
    
    //0.判断这个 parentView 的类型,
    
    //0.1.是scrollview 就直接不让其可以拖动 bounce = no
    
    //0.2. 是普通的 View,不做处理
    
    //1.否是已经展示过
    //1.1.如果已经与 emptyView 这个类,就设置 type
    
    //1.2.没有加加到上面

    
    
    CBWEmptyView *emptyView = [[self alloc]init];
    kCBWOBJCSetObject(self, emptyView);//每一次创建 self, 会不一样
    emptyView.messageLabel.text = message;
    emptyView.frame = parentView.bounds;
    [parentView addSubview:emptyView];

    
}

+ (void)showEmptyViewWithMessage:(NSString *)message Type:(CBWEmptyViewType)type inparentView:(UIView *)parentView clickBlock:(CBWEmptyViewClickBlock )clickBlock{
    
    [self showEmptyViewWithMessage:message Type:type inparentView:parentView];
    
    //获取当前对象
    CBWEmptyView *emptyView = kCBWOBJCGetObject(self);
    emptyView.clickBlock = clickBlock;
    
}

+ (void)showEmptyViewWithMessage:(NSString *)message Type:(CBWEmptyViewType)type inparentView:(UIView *)parentView target:(id)target refreshingAction:(SEL)action{
    
     [self showEmptyViewWithMessage:message Type:type inparentView:parentView];
    
    //获取当前对象
    CBWEmptyView *emptyView = kCBWOBJCGetObject(self);
    emptyView.target = target;
    emptyView.action = action;
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    

    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        
        if (self.clickBlock) {
            self.clickBlock();
        }
        
//        if ([self.target respondsToSelector:self.action]) {
//            CBWEmptyViewMsgSend(CBWEmptyViewMsgTarget(self.target), self.action, self);
//        }
    
    });


    
}

#pragma mark - lauoutSubViews

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    CGSize messageSize = [self.messageLabel.text boundingRectWithSize:CGSizeMake( 250, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.messageLabel.font} context:nil].size;
    
    float contenViewH = messageSize.height + 3 * kCBWEmptyVieMargin + kCBWEmptyVieImageViewWH;
    float contenViewW = self.bounds.size.width;
    self.contentView.frame = CGRectMake(0, 0, contenViewW, contenViewH);
    self.contentView.center = self.center;
    
    float imageViewX = (contenViewW - kCBWEmptyVieImageViewWH)/2.0;
    float imageViewY = kCBWEmptyVieMargin;
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, kCBWEmptyVieImageViewWH, kCBWEmptyVieImageViewWH);
    
    float messageLabelX = (contenViewW - kCBWEmptyVieMessageLabelWidth)/2.0;
    float messageLabelY = CGRectGetMaxY(self.imageView.frame) + kCBWEmptyVieMargin;
    self.messageLabel.frame = CGRectMake(messageLabelX, messageLabelY, kCBWEmptyVieMessageLabelWidth, messageSize.height);
    
}


+ (void)dismiss{
    
    
    
    CBWEmptyView *emptyView = kCBWOBJCGetObject(self);//每一次创建 self, 会不一样
    
    if (emptyView) {
//        NSLog(@"%@",emptyView);
         [emptyView removeFromSuperview];
        
    }
    
   
    
}

#pragma mark - lazy

-(UIView *)contentView{
    
    if (_contentView == nil) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor blueColor];
    }
    return _contentView;
    
}

-(UILabel *)messageLabel{
    
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.backgroundColor = [UIColor greenColor];
    }
    
    return _messageLabel;
}

-(UIImageView *)imageView{
    
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
//        _imageView.backgroundColor = [UIColor redColor];
    
    }
    
    return _imageView;
    
}

@end
