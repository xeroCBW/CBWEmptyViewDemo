//
//  TableViewController.m
//  CBWEmptyViewDemo
//
//  Created by 陈博文 on 16/8/4.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import "TableViewController.h"
#import "CBWEmptyView.h"
#import "TestViewController.h"
#import "TestMJRefreshTableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
//    [CBWEmptyView showEmptyViewWithMessage:@"121312313\n331231312weeqeqeq" Type:CBWEmptyViewTypeLoading inparentView:self.view];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"next" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
   
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    UIBarButtonItem *mjright = [[UIBarButtonItem alloc]initWithTitle:@"mjnext" style:UIBarButtonItemStylePlain target:self action:@selector(mjnextAction)];
    
    
     self.navigationItem.rightBarButtonItems = @[right,mjright];
 }

#pragma mark - Table view data source

- (void)nextAction{
    
    TestViewController *vc = [[TestViewController alloc]init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)mjnextAction{
    
    TestMJRefreshTableViewController *vc = [[TestMJRefreshTableViewController alloc]init];
    vc.view.backgroundColor = [UIColor yellowColor];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

@end
