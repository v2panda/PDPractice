//
//  Book.m
//  DemoMVVM
//
//  Created by Panda on 17/1/10.
//  Copyright © 2017年 v2panda. All rights reserved.
//

#import "Book.h"

@implementation Book

+ (Book *)bookWithDict:(NSDictionary *)value {
    Book *book = [Book new];
    if ([value objectForKey:@"title"]) {
        book.title = [value objectForKey:@"title"];
    }
    if ([value objectForKey:@"subtitle"]) {
        book.subtitle = [value objectForKey:@"subtitle"];
    }
    return book;
}

@end
