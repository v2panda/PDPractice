//
//  ViewController.m
//  DemoMVVM
//
//  Created by Panda on 17/1/9.
//  Copyright © 2017年 v2panda. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewModel.h"

@interface ViewController ()

@property (nonatomic, strong) LoginViewModel *loginViewModel;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
}

#pragma mark - event response
- (void)bindViewModel {
    // 给模型的属性绑定信号
    // 只要账号文本框一改变，就会给account赋值
    RAC(self.loginViewModel.account,account) = self.usernameTextField.rac_textSignal;
    RAC(self.loginViewModel.account,pwd) = self.passwordTextField.rac_textSignal;
    
    // 绑定登录按钮
    RAC(self.loginBtn,enabled) = self.loginViewModel.enableLoginSignal;
    
    // 监听登录按钮点击
    @weakify(self);
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        // 执行登录事件
        @strongify(self);
        self.ImageView.image = [UIImage imageNamed:@"v2panda"];
        [self.loginViewModel.LoginCommand execute:nil];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - getters and setters
- (LoginViewModel *)loginViewModel {
    if (!_loginViewModel) {
        _loginViewModel = [[LoginViewModel alloc] init];
    }
    return _loginViewModel;
}

@end
