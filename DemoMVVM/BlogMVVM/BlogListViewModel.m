//
//  BlogListViewModel.m
//  DemoMVVM
//
//  Created by Panda on 17/1/10.
//  Copyright © 2017年 v2panda. All rights reserved.
//

#import "BlogListViewModel.h"
#import "ArticleModel.h"
#import "BlogListItemViewModel.h"

@interface BlogListViewModel ()


@property (strong, nonatomic) NSNumber * nextPageNumber; //!< 下次要请求第几页的数据.
@property (copy, nonatomic) NSString * category; //!< 文章类别.
@property (copy, nonatomic) NSString * requestPath; //!< 完整接口地址.

@end

@implementation BlogListViewModel
- (instancetype)initWithCategoryArtilceListModel:(NSString *)category {
    if (self = [super init]) {
        self.category = category;
        // 和类型无关的RAC 初始化操作,应该剥离出来.
        [self initialBind];
    }
    return self;
}

- (void)initialBind {
    // 设置 self.nextPageNumber 与self.category的关联.
    [RACObserve(self, category) subscribeNext:^(id x) {
        // 只要分类变化,下次请求,都需要重置为请求第零页的数据.
        self.nextPageNumber = @0;
    }];
    // 接口完整地址,肯定是受分类和页面的影响的.但是因为分类的变化最终会通过分页的变化来体现,所以此处仅需监测分页的变化情况即可.
    [RACObserve(self, nextPageNumber)  subscribeNext:^(NSNumber * nextPageNumber) {
        NSString * path = [NSString stringWithFormat: @"http://www.ios122.com/find_php/index.php?viewController=YFPostListViewController&model[category]=%@&model[page]=%@", self.category, nextPageNumber];
        
        self.requestPath = path;
    }];
    
    // 每次数据完整接口变化时,必然要同步更新 blogListItemViewModels 的值.
    [[RACObserve(self, requestPath) filter:^BOOL(id value) {
        return value;
    }] subscribeNext:^(NSString * path) {
        /**
         *  分两种情况: 如果是变为0,说明是重置数据;如果是大于0,说明是要加载更多数据;不处理向上翻页的情况.
         */
        
        NSMutableArray * articls = [NSMutableArray arrayWithCapacity: 42];
        
        if (YES != [self.nextPageNumber isEqualToNumber: @0]) {
            [articls addObjectsFromArray: self.blogListItemViewModels];
        }
        
        [[self.httpClient rac_GET:path parameters:nil] subscribeNext:^(RACTuple *JSONAndHeaders) {
            // 使用MJExtension将JSON转换为对应的数据模型.
            NSArray * newArticles = [YFArticleModel objectArrayWithKeyValuesArray: JSONAndHeaders.first];
            
            // RAC 风格的数组操作.
            RACSequence * newblogViewModels = [newArticles.rac_sequence
                                               map:^(ArticleModel * model) {
                                                   BlogListItemViewModel * vm = [[BlogListItemViewModel alloc] initWithArticleModel: model];
                                                   
                                                   return vm;
                                               }];
            
            
            [articls addObjectsFromArray: newblogViewModels.array];
            
            self.blogListItemViewModels = articls;
        }];
    }];

}

- (void)first {
    self.nextPageNumber = @0;
}

- (void)next {
    self.nextPageNumber  = [NSNumber numberWithInteger: [self.nextPageNumber integerValue] + 1];
}

@end
