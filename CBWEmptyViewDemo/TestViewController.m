//
//  TestViewController.m
//  CBWEmptyViewDemo
//
//  Created by 陈博文 on 16/8/4.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import "TestViewController.h"
#import "CBWEmptyView.h"
#import <JHUD.h>
#import "DetailViewController.h"
#import "UIView+CBWPlaceHolderView.h"
#import "CBWPlaceHolderView.h"

@interface TestViewController ()

/** 方法数组*/
@property (nonatomic ,strong) NSMutableArray *dataArr;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArr = [NSMutableArray arrayWithArray:@[
                                                    @"setUpReloadDataButton",
                                                    @"setUpFullScreenRefresh",
                                                    @"setUpImageArray",
                                                    @"setUpGifImage"
                                                    ]];

}




#pragma mark - delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",(NSString *)self.dataArr[indexPath.row]];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *vc = [[DetailViewController alloc]init];
//    vc.view.backgroundColor = [UIColor redColor];//不能设置背景颜色,设置后就会selectorStr为空
    
    NSString *str = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.row]];
    vc.selectorStr = str;
    [self.navigationController pushViewController:vc animated:YES];
        
}

#pragma mark - lazy
-(NSMutableArray *)dataArr{
    
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
        
    }
    
    return _dataArr;
    
}

@end
