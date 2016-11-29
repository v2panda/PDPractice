//
//  NSObject+PDKVO.m
//  Demo_KVO
//
//  Created by Panda on 16/11/29.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "NSObject+PDKVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSString *const kPDKVOClassPrefix = @"PDKVOClassPrefix_";
NSString *const kPDKVOAssociatedObservers = @"PDKVOAssociatedObservers";


#pragma mark - PDObservationInfo
@interface PDObservationInfo : NSObject

@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) PDObservingBlock block;

@end

@implementation PDObservationInfo

- (instancetype)initWithObserver:(NSObject *)observer
                             Key:(NSString *)key
                           block:(PDObservingBlock)block {
    self = [super init];
    if (self) {
        _observer = observer;
        _key = key;
        _block = block;
    }
    return self;
}
@end

#pragma mark - Helpers
/**
 *  根据getter方法名返回setter方法名
 */
static NSString * setterForGetter(NSString *getter) {
    if (getter.length <= 0) {
        return nil;
    }
    
    // 首字母转换成大写
    NSString *firstLetter = [[getter substringToIndex:1] uppercaseString];
    NSString *remainingLetters = [getter substringFromIndex:1];
    
    // 最前增加set, 最后增加:
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", firstLetter, remainingLetters];
    
    return setter;
}
/**
 *  根据setter方法名返回getter方法名
 */
static NSString * getterForSetter(NSString *setter) {
    if (setter.length <=0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) {
        return nil;
    }
    
    // remove 'set' at the begining and ':' at the end
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *key = [setter substringWithRange:range];
    
    // lower case the first letter
    NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                       withString:firstLetter];
    
    return key;
}

#pragma mark - Overridden Methods
/**
 *  重写setter方法, 新方法在调用原方法后, 通知每个观察者(调用传入的block)
 */
static void kvo_setter(id self, SEL _cmd, id newValue) {
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterForSetter(setterName);
    
    // 找不到getter方法 抛出异常
    if (!getterName) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have setter %@", self, setterName];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        return;
    }
    
    // 获取旧值
    id oldValue = [self valueForKey:getterName];
    
    // 调用原类的setter方法
    // objc_msgSendSuper 第一个参数需要传一个指向结构体的指针，这跟objc_msgSend参数不同
    struct objc_super superclazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    // cast our pointer so the compiler won't complain
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    
    // call super's setter, which is original class's setter method
    objc_msgSendSuperCasted(&superclazz, _cmd, newValue);
    
    // 找出观察者的数组, 调用对应对象的callback
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(kPDKVOAssociatedObservers));
    for (PDObservationInfo *each in observers) {
        if ([each.key isEqualToString:getterName]) {
            // 这里暂时采用同步调用
            each.block(self, getterName, oldValue, newValue);
            // 也可异步，但注意异步时，若刷新 UI ，记得回到主线程
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                each.block(self, getterName, oldValue, newValue);
//            });
        }
    }
}

/**
 *  模仿Apple的做法, 欺骗人们这个kvo类还是原类
 */
static Class pd_classMethod(id self, SEL _cmd) {
    Class clazz = object_getClass(self);
    return class_getSuperclass(clazz);
}

#pragma mark - KVO Category
@implementation NSObject (PDKVO)

- (void)pd_addObserver:(NSObject *)observer
                forKey:(NSString *)key
             withBlock:(PDObservingBlock)block {
    SEL setterSelector = NSSelectorFromString(setterForGetter(key));
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    // 检查对象的类有没有相应的 setter 方法。如果没有抛出异常
    if (!setterMethod) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have a setter for key %@", self, key];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        return;
    }
    
    // 检查对象 isa 指向的类是不是一个 KVO 类。如果不是，新建一个继承原来类的子类，并把 isa 指向这个新建的子类
    Class clazz = object_getClass(self);
    NSString *clazzName = NSStringFromClass(clazz);
    if (![clazzName hasPrefix:kPDKVOClassPrefix]) {
        clazz = [self createKvoClassWithOriginalClassName:clazzName];
        // 改变 isa 指向刚创建的 clazz 类
        object_setClass(self, clazz);
    }
    
    // 为kvo class添加setter方法的实现
    if (![self hasSelector:setterSelector]) {
        const char *types = method_getTypeEncoding(setterMethod);
        class_addMethod(clazz, setterSelector, (IMP)kvo_setter, types);
    }
    
    // 创建观察者的信息
    PDObservationInfo *info = [[PDObservationInfo alloc] initWithObserver:observer Key:key block:block];
    // 加锁（NSMutableArray 不是线程安全的）
    @synchronized (self) {
        // 获取关联对象(装着所有监听者的数组)
        NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(kPDKVOAssociatedObservers));
        if (!observers) {
            observers = [NSMutableArray array];
            objc_setAssociatedObject(self, (__bridge const void *)(kPDKVOAssociatedObservers), observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [observers addObject:info];
    }
}

- (void)pd_removeObserver:(NSObject *)observer forKey:(NSString *)key {
    NSMutableArray* observers = objc_getAssociatedObject(self, (__bridge const void *)(kPDKVOAssociatedObservers));
    
    PDObservationInfo *infoToRemove;
    for (PDObservationInfo* info in observers) {
        if (info.observer == observer && [info.key isEqual:key]) {
            infoToRemove = info;
            break;
        }
    }
    [observers removeObject:infoToRemove];
}

- (Class)createKvoClassWithOriginalClassName:(NSString *)originalClazzName {
    // 把 PDKVOClassPrefix_ 加在类名前
    NSString *kvoClazzName = [kPDKVOClassPrefix stringByAppendingString:originalClazzName];
    // 创建新类
    Class clazz = NSClassFromString(kvoClazzName);
    // 如果kvo class存在则返回
    if (clazz) {
        return clazz;
    }
    
    // 运行时创建一个originalClazz的子类kvoClazz，同时添加一个实例方法pd_classMethod给kvoClazz
    /**
     *  运行时创建类只需要三步：
     1、为"class pair"分配空间（使用objc_allocateClassPair).
     2、为创建的类添加方法和成员（使用class_addMethod添加了一个方法）。
     3、注册你创建的这个类，使其可用(使用objc_registerClassPair)。
     */
    Class originalClazz = object_getClass(self);
    Class kvoClazz = objc_allocateClassPair(originalClazz, kvoClazzName.UTF8String, 0);
    Method clazzMethod = class_getInstanceMethod(originalClazz, @selector(class));
    const char *types = method_getTypeEncoding(clazzMethod);
    class_addMethod(kvoClazz, @selector(class), (IMP)pd_classMethod, types);
    objc_registerClassPair(kvoClazz);
    
    return kvoClazz;
}

- (BOOL)hasSelector:(SEL)selector {
    Class clazz = object_getClass(self);
    unsigned int methodCount = 0;
    Method* methodList = class_copyMethodList(clazz, &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        SEL thisSelector = method_getName(methodList[i]);
        if (thisSelector == selector) {
            free(methodList);
            return YES;
        }
    }
    
    free(methodList);
    return NO;
}
@end


