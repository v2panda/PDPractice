//
//  BlogListViewModel.h
//  DemoMVVM
//
//  Created by Panda on 17/1/10.
//  Copyright © 2017年 v2panda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlogListViewModel : NSObject

@property (copy, nonatomic) NSArray * blogListItemViewModels; //!< 文章.内部存储的应为文章列表单元格的视图模型.注意: 刷新操作,存储第一页数据;翻页操作,将存储所有的数据,并按页面排序.

@property (nonatomic, strong, readonly) RACCommand *requesCommand;

- (instancetype)initWithCategoryArtilceListModel:(NSString *)category;

/**
 *  获取首页的数据.常用于下拉刷新.
 *
 */
- (void)first;

/**
 *  翻页,获取下一页的数据.常用于上拉加载更多.
 */
- (void)next;

@end
