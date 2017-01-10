//
//  PostListViewController.m
//  DemoMVVM
//
//  Created by Panda on 17/1/10.
//  Copyright © 2017年 v2panda. All rights reserved.
//

#import "PostListViewController.h"
#import "BlogListViewModel.h"

@interface PostListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (strong, nonatomic) BlogListViewModel * viewModel;

@end

@implementation PostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - getters and setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        NSString * cellReuseIdentifier = NSStringFromClass([UITableViewCell class]);
        
        [_tableView registerClass: NSClassFromString(cellReuseIdentifier) forCellReuseIdentifier:cellReuseIdentifier];
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [self.viewModel first];
        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            [self.viewModel next];
        }];

        [self.view addSubview: _tableView];
    }
    return _tableView;
}



@end
