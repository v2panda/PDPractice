//
//  ArticleModel.h
//  DemoMVVM
//
//  Created by Panda on 17/1/10.
//  Copyright © 2017年 v2panda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleModel : NSObject

@property (strong, nonatomic) NSString * id; //!< 文章唯一标识.
@property (copy, nonatomic) NSString * title; //!< 文章标题.
@property (copy, nonatomic) NSString * desc; //!< 文章简介.
@property (copy, nonatomic) NSString * body; //!< 文章详情.

@end
