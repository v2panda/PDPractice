//
//  LoginViewModel.m
//  DemoMVVM
//
//  Created by Panda on 17/1/9.
//  Copyright © 2017年 v2panda. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self initialBind];
    }
    return self;
}

- (void)initialBind {
    // 监听账号属性值改变，把它们聚合成一个信号
    _enableLoginSignal = [RACSignal combineLatest:@[RACObserve(self.account, account),RACObserve(self.account, pwd)] reduce:^id(NSString *account,NSString *pwd){
        return @(account.length && pwd.length);
    }];
    
    // 处理业务登录逻辑
    _LoginCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"1.点击了登录");
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            // 模仿网络延迟
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [subscriber sendNext:@"登录成功"];
                
                // 数据传送完毕，必须调用完成，否则命令永远处于执行状态
                [subscriber sendCompleted];
            });
            return nil;
        }];
    }];
    
    // 监听登录产生的数据
    [_LoginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
        if ([x isEqualToString:@"登录成功"]) {
            NSLog(@"3.登录成功");
        }
    }];
    
    // 监听登录状态
    [[_LoginCommand.executing skip:1] subscribeNext:^(id x) {
        if ([x isEqualToNumber:@(YES)]) {
            
            // 正在登录ing...
            // 用蒙版提示
            [MBProgressHUD showMessage:@"正在登录..."];
            NSLog(@"2.正在登录...");
            
        }else
        {
            // 登录成功
            // 隐藏蒙版
            [MBProgressHUD hideHUD];
            NSLog(@"4.登录完成...");
        }
    }];
}

#pragma mark - getters and setters
- (Account *)account {
    if (!_account) {
        _account = [[Account alloc] init];
    }
    return _account;
}

@end
