//
//  BlogListItemViewModel.m
//  DemoMVVM
//
//  Created by Panda on 17/1/10.
//  Copyright © 2017年 v2panda. All rights reserved.
//

#import "BlogListItemViewModel.h"
#import "ArticleModel.h"

@implementation BlogListItemViewModel
- (instancetype)initWithArticleModel:(ArticleModel *)model
{
    self = [super init];
    
    if (nil != self) {
        // 设置intro属性和model的属性的级联关系.
        RAC(self, intro) = [RACSignal combineLatest:@[RACObserve(model, title), RACObserve(model, desc)] reduce:^id(NSString * title, NSString * desc){
            NSString * intro = [NSString stringWithFormat: @"标题:%@ 内容:%@", model.title, model.desc];
            
            return intro;
        }];
        
        // 设置self.blogId与model.id的相互关系.
        [RACObserve(model, id) subscribeNext:^(id x) {
            self.blogId = x;
        }];
    }
    
    return self;
}
@end
