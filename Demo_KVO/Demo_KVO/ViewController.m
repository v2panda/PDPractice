//
//  ViewController.m
//  Demo_KVO
//
//  Created by Panda on 16/11/28.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Boy.h"
#import "Girl.h"

@interface ViewController ()

@property (nonatomic, strong) Person *person;

@property (nonatomic, strong) Boy *boy;

@end

static void *PersonNameContext = &PersonNameContext;
static void *PersonAgeContext = &PersonAgeContext;
static void *PersonInformationContext = &PersonInformationContext;
static void *PersonTotalAgesContext = &PersonTotalAgesContext;
static void *BoyNameContext = &BoyNameContext;
static void *BoyAgeContext = &BoyAgeContext;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
}

- (void)addObserver {
    self.person = [Person new];
    self.boy = [Boy new];
    [self.person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:PersonNameContext];
    [self.person addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:PersonAgeContext];
    [self.person addObserver:self forKeyPath:@"information" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:PersonInformationContext];
    [self.person addObserver:self forKeyPath:@"totalAges" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:PersonTotalAgesContext];
    
    [self.boy addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:BoyNameContext];
    [self.boy addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:BoyAgeContext];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (context == PersonNameContext) {
        NSLog(@"PersonNameContext:%@,%@",change[@"new"],change[@"old"]);
    }else if (context == PersonAgeContext) {
        NSLog(@"PersonAgeContext:%@,%@",change[@"new"],change[@"old"]);
    }else if (context == PersonInformationContext) {
        NSLog(@"PersonInformationContext:%@,%@",change[@"new"],change[@"old"]);
    }else if (context == PersonTotalAgesContext) {
        NSLog(@"PersonTotalAgesContext:%@,%@",change[@"new"],change[@"old"]);
    }else if (context == BoyNameContext) {
        NSLog(@"BoyNameContext:%@,%@",change[@"new"],change[@"old"]);
    }else if (context == BoyAgeContext) {
        NSLog(@"BoyAgeContext:%@,%@",change[@"new"],change[@"old"]);
    }else {
        // Any unrecognized context must belong to super
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

#pragma mark - event response
- (IBAction)changePersonName:(id)sender {
    self.person.name = @"asd";
}
- (IBAction)changeBoyName:(id)sender {
    [self.boy setName:@"haha"];
}
- (IBAction)changePersonAge:(id)sender {
    self.person.age = 123;
}
- (IBAction)changeBoyAge:(id)sender {
    self.boy.age = 233;
}
- (IBAction)changeGirls:(id)sender {
    Girl *girl = [Girl new];
    girl.age = 10;
    self.person.girls = @[girl,girl,girl,girl];
}

#pragma mark - dealloc
- (void)dealloc {
    [self.person removeObserver:self forKeyPath:@"name"] ;
    [self.person removeObserver:self forKeyPath:@"age"] ;
    [self.person removeObserver:self forKeyPath:@"information"] ;
    [self.person removeObserver:self forKeyPath:@"totalAges"] ;
    [self.boy removeObserver:self forKeyPath:@"name"] ;
    [self.boy removeObserver:self forKeyPath:@"age"] ;
}
@end
