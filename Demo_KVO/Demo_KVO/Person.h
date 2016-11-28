//
//  Person.h
//  Demo_KVO
//
//  Created by Panda on 16/11/28.
//  Copyright © 2016年 v2panda. All rights reserved.
//
// 自动实现的 KVO
#import <Foundation/Foundation.h>
#import "Girl.h"

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) int age;

// 存储 Girl 对象
@property (nonatomic, strong) NSArray *girls;

// To-one 依赖键
@property (nonatomic, copy) NSString *information;

// To-many 依赖键  (totalAges 为所有 girls 里 girl 的 age 的和)
@property (nonatomic, assign) int totalAges;

@end
