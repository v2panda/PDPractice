//
//  RequestViewModel.m
//  DemoMVVM
//
//  Created by Panda on 17/1/10.
//  Copyright © 2017年 v2panda. All rights reserved.
//

#import "RequestViewModel.h"
#import "Book.h"

@implementation RequestViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self initialBind];
    }
    return self;
}

- (void)initialBind {
    _requesCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
       RACSignal *requesSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           // 发送请求
           [[AFHTTPSessionManager manager]GET:@"https://api.douban.com/v2/book/search" parameters:@{@"q":@"基础"} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//               NSLog(@"%@",responseObject);
               NSLog(@"请求成功调用");
               // 请求成功调用
               // 把数据用信号传递出去
               [subscriber sendNext:responseObject];
               
               [subscriber sendCompleted];
               
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               
           }];
           return nil;
       }];
        // 在返回数据信号时，把数据中的字典映射成模型信号，传递出去
        return [requesSignal map:^id(NSDictionary * value) {
            NSMutableArray *dictArr = value[@"books"];
            
             //字典转模型，遍历字典中的所有元素，全部映射成模型，并且生成数组
            NSArray *modelArr = [[dictArr.rac_sequence map:^id(id value) {
                
                return [Book bookWithDict:value];
            }] array];
            
            return modelArr;
        }];
    }];
}



@end
