//
//  MBProgressHUD+Helper.m
//  DemoMVVM
//
//  Created by Panda on 17/1/10.
//  Copyright © 2017年 v2panda. All rights reserved.
//

#import "MBProgressHUD+Helper.h"

@implementation MBProgressHUD (Helper)

+ (void)showMessage:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.detailsLabel.text = message;
    hud.detailsLabel.font = [UIFont systemFontOfSize:12];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    //布局
    [hud layoutIfNeeded];
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.5f];
}

+ (void)hideHUD {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

@end
