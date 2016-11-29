//
//  NSObject+PDKVO.h
//  Demo_KVO
//
//  Created by Panda on 16/11/29.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PDObservingBlock)(id observedObject, NSString *observedKey, id oldValue, id newValue);

@interface NSObject (PDKVO)

- (void)pd_addObserver:(NSObject *)observer
                forKey:(NSString *)key
             withBlock:(PDObservingBlock)block;

- (void)pd_removeObserver:(NSObject *)observer forKey:(NSString *)key;

@end
