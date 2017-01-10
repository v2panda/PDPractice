//
//  RequestViewModel.h
//  DemoMVVM
//
//  Created by Panda on 17/1/10.
//  Copyright © 2017年 v2panda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestViewModel : NSObject
/**
 *  请求命令
 */
@property (nonatomic, strong) RACCommand *requesCommand;
/**
 *  模型数组
 */
@property (nonatomic, strong) NSArray *models;

@end
