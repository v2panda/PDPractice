//
//  Person.m
//  Demo_KVO
//
//  Created by Panda on 16/11/28.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "Person.h"

static void *totalAgesContext = &totalAgesContext;

@implementation Person

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:@"girls" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:totalAgesContext];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == totalAgesContext) {
        NSLog(@"totalAgesContext:%@,%@",change[@"new"],change[@"old"]);
        [self updateTotalAges];
    }else {
        // Any unrecognized context must belong to super
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (void)updateTotalAges {
    NSString *sum = (NSString *)[self valueForKeyPath:@"girls.@sum.age"];
    [self setTotalAges:sum.intValue];
}

/**
 *  依赖键 information 依赖 name 和 age
 */
- (NSString *)information {
    return [NSString stringWithFormat:@"%@-%d",_name,_age];
}

#pragma mark - 两种写法 任选
+ (NSSet *)keyPathsForValuesAffectingInformation {
    NSSet * keyPaths = [NSSet setWithObjects:@"age", @"name", nil];
    return keyPaths;
}

//+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
//    
//    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
//    
//    if ([key isEqualToString:@"information"]) {
//        keyPaths = [keyPaths setByAddingObjectsFromArray:@[@"name", @"age"]];
//    }
//    return keyPaths;
//}

@end
