//
//  Book.h
//  DemoMVVM
//
//  Created by Panda on 17/1/10.
//  Copyright © 2017年 v2panda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subtitle;

+ (Book *)bookWithDict:(NSDictionary *)value;

@end
