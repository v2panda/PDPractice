//
//  LoginViewModel.h
//  DemoMVVM
//
//  Created by Panda on 17/1/9.
//  Copyright © 2017年 v2panda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface LoginViewModel : NSObject
/**
 *  账户信息
 */
@property (nonatomic, strong) Account *account;
/**
 *  是否允许登录的信号
 */
@property (nonatomic, strong, readonly) RACSignal *enableLoginSignal;

@property (nonatomic, strong, readonly) RACCommand *LoginCommand;

@end
