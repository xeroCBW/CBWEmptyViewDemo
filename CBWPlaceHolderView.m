//
//  CBWPlaceHolderView.m
//  CBWEmptyViewDemo
//
//  Created by 陈博文 on 16/8/5.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import "CBWPlaceHolderView.h"
#import <objc/message.h>
#import <ImageIO/ImageIO.h>

// 运行时objc_msgSend
#define CBWPlaceHolderViewMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define CBWPlaceHolderViewMsgTarget(target) (__bridge void *)(target)

static CGFloat kCBWEmptyVieMargin = 10.0;
static CGFloat kCBWEmptyVieMessageLabelWidth = 250.0;
static CGFloat kCBWEmptyVieImageViewWH = 80.0;
static CGFloat kCBWEmptyViewButtonHeight = 40;

#define kCBWEmptyViewButtonWidth (self.bounds.size.width - 2 * kCBWEmptyVieMargin)

@interface CBWPlaceHolderView ()

/** contentView*/
@property (nonatomic ,strong) UIView *contentView;

/** label*/
@property (nonatomic ,strong) UILabel *messageLabel;

/** imageView*/
@property (nonatomic ,strong) UIImageView *imageView;

/** button*/
@property (nonatomic ,strong) UIButton *button;

/** parentView*/
@property (nonatomic ,weak) UIView *parentView;

/** 回调对象 */
@property (weak, nonatomic) id target;
/** 回调方法 */
@property (assign, nonatomic) SEL action;

@end


@implementation CBWPlaceHolderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.hidden = NO;
        self.frame = self.parentView.bounds;
        [self setUpSubView];
    }
    return self;
}

- (void)setUpSubView{
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.messageLabel];
    
    [self addSubview:self.contentView];
    
    [self.parentView addSubview:self];
 }


+ (instancetype)showEmptyViewWithType:(CBWPlaceHolderViewType)type inParentView:(UIView *)parentView{
    
       
    CBWPlaceHolderView *cmp = [[self alloc]init];
    cmp.parentView = parentView;
    
    //不能弹簧效果
    if ([parentView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *view = (UIScrollView *)parentView;
        view.bounces = NO;
    }
    
    switch (type) {
        case CBWPlaceHolderViewTypeLoading: {
            
            NSMutableArray * images = [NSMutableArray array];
            for (int index = 0; index<=19; index++) {
                NSString * imageName = [NSString stringWithFormat:@"%d.png",index];
                UIImage *image = [UIImage imageNamed:imageName];
                [images addObject:image];
            }
            cmp.messageLabel.text = @"正在加载中...";
            cmp.customAnimationImages = images;
            break;
        }
        case CBWPlaceHolderViewTypeNomoredata: {
            cmp.messageLabel.text = @"暂无数据";
            cmp.customImage = [UIImage imageNamed:@"norecord"];
            break;
        }
        case CBWPlaceHolderViewTypeNetworkError: {
            cmp.messageLabel.text = @"网络异常";
            cmp.customImage = [UIImage imageNamed:@"nullData"];
            break;
        }
    }
    
    
    return cmp;
}

+ (instancetype)showEmptyViewWithMessage:(NSString *)message inparentView:(UIView *)parentView{
    
    //不能弹簧效果
    if ([parentView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *view = (UIScrollView *)parentView;
        view.bounces = NO;
    }
    
    CBWPlaceHolderView *cmp = [[self alloc]init];
    
    cmp.parentView = parentView;
    cmp.messageLabel.text = message;
    
    
    return cmp;
}


+ (instancetype)showEmptyViewWithMessage:(NSString *)message inparentView:(UIView *)parentView target:(id)target action:(SEL)action{

    CBWPlaceHolderView *cmp = [self showEmptyViewWithMessage:message inparentView:parentView];
    cmp.target = target;
    cmp.action = action;
  
    return cmp;
    
}


-(void)addButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    self.buttonTiltle = title;
    self.buttonTarget = target;
    self.buttonAction = action;
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    

    dispatch_async(dispatch_get_main_queue(), ^{
        
                if ([self.target respondsToSelector:self.action]) {
                    CBWPlaceHolderViewMsgSend(CBWPlaceHolderViewMsgTarget(self.target), self.action, self);
                }
        
    });
    
    
    
}
/**
 *  消失,实际上是隐藏
 */
- (void)dismiss{
    
    if ([self.parentView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *view = (UIScrollView *)self.parentView;
        view.bounces = YES;
    }
    
    [self.imageView stopAnimating];
    self.hidden = YES;
    
}

#pragma mark - lauoutSubViews

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.frame = self.parentView.bounds;
    
    CGSize messageSize = [self.messageLabel.text boundingRectWithSize:CGSizeMake( 250, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.messageLabel.font} context:nil].size;
    
    float imageViewW = self.customImage ?self.customImage.size.width:kCBWEmptyVieImageViewWH;
    float imageViewH = self.customImage ?self.customImage.size.height:kCBWEmptyVieImageViewWH;
    float imageViewX = (self.bounds.size.width - imageViewW)/2.0;
    float imageViewY = kCBWEmptyVieMargin;
       self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    
    //设置图片
    if (self.customAnimationImages&&!self.imageView.image&&!self.imageView.animationImages) {
        self.imageView.animationImages = self.customAnimationImages;
        [self.imageView startAnimating];
    }
    
    if (self.customImage&& !self.imageView.image && !self.imageView.animationImages ) {
        self.imageView.image = self.customImage;
    }
    
    if (self.gifImageData &&!self.imageView.image&&!self.imageView.animationImages) {
        //1.获得全局的并发队列
     dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //2.添加任务到队列中，就可以执行任务
        //异步函数：具备开启新线程的能力
        dispatch_async(queue, ^{
            UIImage *gifImage = [CBWPlaceHolderView CBWPlaceHolderViewHUDImageWithSmallGIFData:self.gifImageData scale:1.0];
             NSLog(@"%@",[NSThread currentThread]);
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = gifImage;
                //打印当前线程
                NSLog(@"%@",[NSThread currentThread]);
            });
            
            
        });
    }
    
    float messageLabelX = (self.bounds.size.width - kCBWEmptyVieMessageLabelWidth)/2.0;
    float messageLabelY = CGRectGetMaxY(self.imageView.frame) + kCBWEmptyVieMargin;
    self.messageLabel.frame = CGRectMake(messageLabelX, messageLabelY, kCBWEmptyVieMessageLabelWidth, messageSize.height);
    
    float buttonX = (self.bounds.size.width - kCBWEmptyViewButtonWidth)/2.0;
    float buttonY = CGRectGetMaxY(self.messageLabel.frame) + kCBWEmptyVieMargin;
    if (self.buttonTiltle) {
        //加上去
         [self.contentView addSubview:_button];
        
        self.button.frame = CGRectMake(buttonX, buttonY, kCBWEmptyViewButtonWidth, kCBWEmptyViewButtonHeight);
        
        [self.button setTitle:self.buttonTiltle forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(bottonClickAction) forControlEvents:UIControlEventTouchUpInside];
        
           }
    
    float contenViewH = messageSize.height + 3 * kCBWEmptyVieMargin + imageViewH;
    if (self.buttonTiltle) {
        contenViewH += kCBWEmptyViewButtonHeight + kCBWEmptyVieMargin;
    }
    
    float contenViewW = self.bounds.size.width;
    self.contentView.frame = CGRectMake(0, 0, contenViewW, contenViewH);
    self.contentView.center = self.center;
}

#pragma mark - setter

-(void)setMessageFont:(UIFont *)messageFont{
    
    _messageFont = messageFont;
    
    self.messageLabel.font = messageFont;
    
}
-(void)setMessageTextColor:(UIColor *)messageTextColor{
    
    _messageTextColor = messageTextColor;
    
    self.messageLabel.textColor = messageTextColor;
}

-(void)setButtonBackgroundColor:(UIColor *)buttonBackgroundColor{
    _buttonTitleColor = buttonBackgroundColor;
    [self.button setBackgroundImage:[self imageWithColor:buttonBackgroundColor] forState:UIControlStateNormal];
}

-(void)setButtonTitleFont:(UIFont *)buttonTitleFont{
    
    _buttonTitleFont = buttonTitleFont;
    self.button.titleLabel.font = buttonTitleFont;
}

-(void)setButtonTitleColor:(UIColor *)buttonTitleColor{
    
    _buttonTitleColor = buttonTitleColor;
    
    [self.button setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    
}



#pragma mark - lazy

-(UIView *)contentView{
    
    if (_contentView == nil) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
    
}

-(UILabel *)messageLabel{
    
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor lightGrayColor];
        _messageLabel.font = [UIFont systemFontOfSize:16];
        _messageLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _messageLabel;
}

-(UIImageView *)imageView{
    
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
//        _imageView.backgroundColor = [UIColor redColor];
        _imageView.animationDuration = 1.0;
        _imageView.animationRepeatCount = 0;
        
    }
    
    return _imageView;
    
}

-(UIButton *)button{
    
    if (_button == nil) {
        _button = [[UIButton alloc]init];
        _button.backgroundColor = [UIColor orangeColor];
        
    }
    
    return _button;
    
}


- (void)bottonClickAction{
   
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.ButtonClickedBlock) {
            self.ButtonClickedBlock();
        }
        if ([self.buttonTarget respondsToSelector:self.buttonAction]) {
            CBWPlaceHolderViewMsgSend(CBWPlaceHolderViewMsgTarget(self.buttonTarget), self.buttonAction, self);
        }
    });
    
}

#pragma mark - gif 图片转换

// See YYWebImage for details.
+ (UIImage *)CBWPlaceHolderViewHUDImageWithSmallGIFData:(NSData *)data scale:(CGFloat)scale {
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFTypeRef)(data), NULL);
    if (!source) return nil;
    
    size_t count = CGImageSourceGetCount(source);
    if (count <= 1) {
        CFRelease(source);
        return [self.class imageWithData:data scale:scale];
    }
    
    NSUInteger frames[count];
    double oneFrameTime = 1 / 50.0; // 50 fps
    NSTimeInterval totalTime = 0;
    NSUInteger totalFrame = 0;
    NSUInteger gcdFrame = 0;
    for (size_t i = 0; i < count; i++) {
        NSTimeInterval delay = CBWPlaceHolderViewCGImageSourceGetGIFFrameDelayAtIndex(source, i);
        totalTime += delay;
        NSInteger frame = lrint(delay / oneFrameTime);
        if (frame < 1) frame = 1;
        frames[i] = frame;
        totalFrame += frames[i];
        if (i == 0) gcdFrame = frames[i];
        else {
            NSUInteger frame = frames[i], tmp;
            if (frame < gcdFrame) {
                tmp = frame; frame = gcdFrame; gcdFrame = tmp;
            }
            while (true) {
                tmp = frame % gcdFrame;
                if (tmp == 0) break;
                frame = gcdFrame;
                gcdFrame = tmp;
            }
        }
    }
    NSMutableArray *array = [NSMutableArray new];
    for (size_t i = 0; i < count; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        if (!imageRef) {
            CFRelease(source);
            return nil;
        }
        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        if (width == 0 || height == 0) {
            CFRelease(source);
            CFRelease(imageRef);
            return nil;
        }
        
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }
        // BGRA8888 (premultiplied) or BGRX8888
        // same as UIGraphicsBeginImageContext() and -[UIView drawRect:]
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, space, bitmapInfo);
        CGColorSpaceRelease(space);
        if (!context) {
            CFRelease(source);
            CFRelease(imageRef);
            return nil;
        }
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef); // decode
        CGImageRef decoded = CGBitmapContextCreateImage(context);
        CFRelease(context);
        if (!decoded) {
            CFRelease(source);
            CFRelease(imageRef);
            return nil;
        }
        UIImage *image = [UIImage imageWithCGImage:decoded scale:scale orientation:UIImageOrientationUp];
        CGImageRelease(imageRef);
        CGImageRelease(decoded);
        if (!image) {
            CFRelease(source);
            return nil;
        }
        for (size_t j = 0, max = frames[i] / gcdFrame; j < max; j++) {
            [array addObject:image];
        }
    }
    CFRelease(source);
    UIImage *image = [UIImage animatedImageWithImages:array duration:totalTime];
    return image;
}


static NSTimeInterval CBWPlaceHolderViewCGImageSourceGetGIFFrameDelayAtIndex(CGImageSourceRef source, size_t index) {
    NSTimeInterval delay = 0;
    CFDictionaryRef dic = CGImageSourceCopyPropertiesAtIndex(source, index, NULL);
    if (dic) {
        CFDictionaryRef dicGIF = CFDictionaryGetValue(dic, kCGImagePropertyGIFDictionary);
        if (dicGIF) {
            NSNumber *num = CFDictionaryGetValue(dicGIF, kCGImagePropertyGIFUnclampedDelayTime);
            if (num.doubleValue <= __FLT_EPSILON__) {
                num = CFDictionaryGetValue(dicGIF, kCGImagePropertyGIFDelayTime);
            }
            delay = num.doubleValue;
        }
        CFRelease(dic);
    }
    
    // http://nullsleep.tumblr.com/post/16524517190/animated-gif-minimum-frame-delay-browser-compatibility
    if (delay < 0.02) delay = 0.1;
    return delay;
}

#pragma mark - 颜色转图片

/**
 *   颜色转换为背景图片
 */
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
