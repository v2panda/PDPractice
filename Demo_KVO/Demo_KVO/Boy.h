//
//  Boy.h
//  Demo_KVO
//
//  Created by Panda on 16/11/28.
//  Copyright © 2016年 v2panda. All rights reserved.
//
// 手动实现的 KVO
#import <Foundation/Foundation.h>

@interface Boy : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) int age;

@end
