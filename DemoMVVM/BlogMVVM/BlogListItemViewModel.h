//
//  BlogListItemViewModel.h
//  DemoMVVM
//
//  Created by Panda on 17/1/10.
//  Copyright © 2017年 v2panda. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ArticleModel;

/**
 *  用于博客列表,单个单元格的视图模型.
 */
@interface BlogListItemViewModel : NSObject
@property (copy, nonatomic) NSString * blogId; //!< 文章id.
@property (copy, nonatomic) NSString * intro; //!< 用于显示的文章介绍.

/**
 *  便利构造器,方便从ArticleModel初始化.
 *
 *  @param model 文章模型.
 *
 *  @return 类实例对象.
 */
- (instancetype)initWithArticleModel: (ArticleModel *) model;
@end
