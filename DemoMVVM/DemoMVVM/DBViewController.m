//
//  DBViewController.m
//  DemoMVVM
//
//  Created by Panda on 17/1/10.
//  Copyright © 2017年 v2panda. All rights reserved.
//

#import "DBViewController.h"
#import "RequestViewModel.h"
#import "Book.h"

@interface DBViewController () <UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) RequestViewModel *requesViewModel;

@end

@implementation DBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    // 执行请求
    RACSignal *requesSignal = [self.requesViewModel.requesCommand execute:nil];
    @weakify(self);
    // 获取请求的数据
    [requesSignal subscribeNext:^(NSArray *x) {
        @strongify(self);
        self.requesViewModel.models = x;
        [self.tableView reloadData];
    }];
}

- (void)initUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.requesViewModel.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    Book *book = self.requesViewModel.models[indexPath.row];
    cell.detailTextLabel.text = book.subtitle;
    cell.textLabel.text = book.title;
    
    return cell;
}

#pragma mark - getters and setters
- (RequestViewModel *)requesViewModel {
    if (_requesViewModel == nil) {
        _requesViewModel = [[RequestViewModel alloc] init];
    }
    return _requesViewModel;
}

@end
