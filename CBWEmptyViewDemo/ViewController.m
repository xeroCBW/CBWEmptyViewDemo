//
//  ViewController.m
//  CBWEmptyViewDemo
//
//  Created by 陈博文 on 16/8/3.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import "ViewController.h"
#import "CBWEmptyView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self setUpEmpetyView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [CBWEmptyView dismiss];
    });
}

- (void)setUpEmpetyView{
    
    [CBWEmptyView showEmptyViewWithMessage:@"121312313\n331231312" Type:CBWEmptyViewTypeLoading inparentView:self.view clickBlock:^{
        
        
        
    }];
    
}

- (void)blockAction{
    
    
    NSLog(@"blockAction");
}

@end
