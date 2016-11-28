//
//  Boy.m
//  Demo_KVO
//
//  Created by Panda on 16/11/28.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "Boy.h"

@implementation Boy

#pragma mark - getters and setters
/**
 *  手动发送通知
 */
- (void)setName:(NSString *)name {
    if (_name != name) {
        [self willChangeValueForKey:@"name"];
        _name = name;
        [self didChangeValueForKey:@"name"];
    }
}

- (void)setAge:(int)age {
    if (_age != age) {
        [self willChangeValueForKey:@"age"];
        _age = age;
        [self didChangeValueForKey:@"age"];
    }
}

/**
 *  重写此方法，设置对该 key 不自动发送通知
 */
+ (BOOL) automaticallyNotifiesObserversForKey:(NSString *)key {
    if ([key isEqualToString:@"name"]) {
        return NO;
    }else if ([key isEqualToString:@"age"]) {
        return NO;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

@end
