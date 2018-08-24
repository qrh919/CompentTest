//
//  NSObject+QKVC.m
//  CompentTest
//
//  Created by qrh
//

#import "NSObject+QKVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSString *const QKVOPerfix = @"QKVONotifying_";
NSString *const QKVOAssicationKey = @"QKVOAssicationKey";

@implementation NSObject (QKVO)

-(void)q_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath withHandle:(QKVOBlock)handle{
    //1 需判断是否为属性并且实现了setter方法
    Class superClass = object_getClass(self);
    SEL setterSeletor = NSSelectorFromString(setterFormGetter(keyPath));
    
    Method setterMethod = class_getInstanceMethod(superClass, setterSeletor);
    
    if(!setterMethod){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%@ 没有 %@ setter方法",self,keyPath] userInfo:nil];
    }
    
    //2.动态添加子类
    NSString *superClassName = NSStringFromClass(superClass);
    Class subClass;
    if(![superClassName hasPrefix:QKVOPerfix]){
        subClass = [self createClassFromSuperClass:superClassName];
        //将当前类的isa指针指向新建的子类
        object_setClass(self, subClass);
    }
    
    //3.检查KVO生成的子类是否重写了父类的setter方法，没有则添加
    if(![self hasSelector:setterSeletor]){
        const char *types = method_getTypeEncoding(setterMethod);
        char *type = method_copyArgumentType(setterMethod, 2);
        if (strcmp(type, "@") == 0) {//对象类型 NSObject
            class_addMethod(subClass, setterSeletor, (IMP)kvo_setter, types);
        }else if (strcmp(type, @encode(long))  == 0) {
            class_addMethod(subClass, setterSeletor, (IMP)long_setter, types);
        }else if (strcmp(type, @encode(int)) == 0) {
            class_addMethod(subClass, setterSeletor, (IMP)int_setter, types);
        }else if (strcmp(type, @encode(float)) == 0) {
            class_addMethod(subClass, setterSeletor, (IMP)float_setter, types);
        }else if (strcmp(type, @encode(double))  == 0) {
            class_addMethod(subClass, setterSeletor, (IMP)double_setter, types);
        }else if (strcmp(type, @encode(BOOL)) == 0) {
            class_addMethod(subClass, setterSeletor, (IMP)bool_setter, types);
        }
    }
    
    // 4. 添加该观察者到观察者列表中
    // 4.1 创建观察者相关信息字典(观察者对象、观察的key、block)
    NSDictionary *infoDic = @{@"observer":observer,@"key":keyPath,@"handle":handle};
    // 4.2 获取关联对象(所有观察者的数组)
    NSMutableArray *observers = objc_getAssociatedObject(self, &QKVOAssicationKey);
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, &QKVOAssicationKey, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [observers addObject:infoDic];
};

//动态创建子类
-(Class)createClassFromSuperClass:(NSString *)superClassName{
    Class superClass = object_getClass(self);
    NSString *subClassName = [QKVOPerfix stringByAppendingString:superClassName];
    Class subClass = NSClassFromString(subClassName);
    //如果存在则返回
    if(subClass) return superClass;
    
    subClass = objc_allocateClassPair(superClass, [subClassName UTF8String], 0);
    
    //添加子类方法
    Method classMethod = class_getClassMethod(superClass, @selector(class));
    const char *type = method_getTypeEncoding(classMethod);
    
    class_addMethod(subClass, @selector(class), (IMP)QKVO_Class, type);
    
    //注册子类
    objc_registerClassPair(subClass);
    
    return subClass;
}


// 判断是否有该方法
- (BOOL)hasSelector:(SEL)selector
{
    Class class = object_getClass(self);
    unsigned int methodCount = 0;
    // 获取所有方法列表，遍历比较
    Method* methodList = class_copyMethodList(class, &methodCount);
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

#pragma mark - 重写各种类型的setter方法，新方法在调用原方法后, 通知每个观察者(调用传入的block)

//对象类型
static void kvo_setter(id self, SEL _cmd, id newValue)
{
    
    // 1.  获取旧值
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterFormSetter(setterName);
    id oldValue = [self valueForKey:getterName];
    
    // 2. 调用父类方法
    struct objc_super superClazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    objc_msgSendSuper(&superClazz, _cmd, newValue);
    
    // 3、获取观察者列表，遍历找出对应的观察者，执行响应的block
    NSMutableArray *observers = objc_getAssociatedObject(self, &QKVOAssicationKey);
    for (NSDictionary *info in observers) {
        if ([info[@"key"] isEqualToString:getterName]) {
            // gcd异步调用handler
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ((QKVOBlock)info[@"handle"])(info[@"observer"], getterName, oldValue, newValue);
            });
        }
    }
}

//long 类型
static void long_setter(id self, SEL _cmd, long newValue)
{
    // 1. 检查getter方法是否存在
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterFormSetter(setterName);
    if (!getterName) {
        
        return;
    }
    
    // 2. 获取旧值
    id oldValue = [self valueForKey:getterName];
    
    // 3. 调用父类方法
    struct objc_super superClazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    objc_msgSendSuper(&superClazz, _cmd, newValue);
    
    // 4、获取观察者列表，遍历找出对应的观察者，执行响应的block
    NSMutableArray *observers = objc_getAssociatedObject(self, &QKVOAssicationKey);
    for (NSDictionary *info in observers) {
        if ([info[@"key"] isEqualToString:getterName]) {
            // gcd异步调用handler
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ((QKVOBlock)info[@"handle"])(info[@"observer"], getterName, oldValue, [NSNumber numberWithLong:newValue]);
            });
        }
    }
}

//int 类型
static void int_setter(id self, SEL _cmd, int newValue)
{
    // 1. 检查getter方法是否存在
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterFormSetter(setterName);
    if (!getterName) {
        return;
    }
    
    // 2. 获取旧值
    id oldValue = [self valueForKey:getterName];
    
    // 3. 调用父类方法
    struct objc_super superClazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    objc_msgSendSuper(&superClazz, _cmd, newValue);
    
    // 4、获取观察者列表，遍历找出对应的观察者，执行响应的block
    NSMutableArray *observers = objc_getAssociatedObject(self, &QKVOAssicationKey);
    for (NSDictionary *info in observers) {
        if ([info[@"key"] isEqualToString:getterName]) {
            // gcd异步调用handler
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ((QKVOBlock)info[@"handle"])(info[@"observer"], getterName, oldValue, [NSNumber numberWithInt:newValue]);
            });
        }
    }
}

//float 类型
static void float_setter(id self, SEL _cmd, float newValue)
{
    // 1. 检查getter方法是否存在
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterFormSetter(setterName);
    if (!getterName) {
        
        return;
    }
    
    // 2. 获取旧值
    id oldValue = [self valueForKey:getterName];
    
    // 3. 调用父类方法
    struct objc_super superClazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    
    objc_msgSendSuper(&superClazz, _cmd, newValue);
    
    // 4、获取观察者列表，遍历找出对应的观察者，执行响应的block
    NSMutableArray *observers = objc_getAssociatedObject(self, &QKVOAssicationKey);
    for (NSDictionary *info in observers) {
        if ([info[@"key"] isEqualToString:getterName]) {
            // gcd异步调用handler
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ((QKVOBlock)info[@"handle"])(info[@"observer"], getterName, oldValue, [NSNumber numberWithFloat:newValue]);
            });
        }
    }
}


//double 类型
static void double_setter(id self, SEL _cmd, double newValue)
{
    // 1. 检查getter方法是否存在
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterFormSetter(setterName);
    if (!getterName) {
        
        return;
    }
    
    // 2. 获取旧值
    id oldValue = [self valueForKey:getterName];
    
    // 3. 调用父类方法
    struct objc_super superClazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    objc_msgSendSuper(&superClazz, _cmd, newValue);
    
    // 4、获取观察者列表，遍历找出对应的观察者，执行响应的block
    NSMutableArray *observers = objc_getAssociatedObject(self, &QKVOAssicationKey);
    for (NSDictionary *info in observers) {
        if ([info[@"key"] isEqualToString:getterName]) {
            // gcd异步调用handler
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ((QKVOBlock)info[@"handle"])(info[@"observer"], getterName, oldValue, [NSNumber numberWithDouble:newValue]);
            });
        }
    }
}


//bool 类型
static void bool_setter(id self, SEL _cmd, BOOL newValue)
{
    // 1. 检查getter方法是否存在
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterFormSetter(setterName);
    if (!getterName) {
        
        return;
    }
    
    // 2. 获取旧值
    id oldValue = [self valueForKey:getterName];
    
    // 3. 调用父类方法
    struct objc_super superClazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    objc_msgSendSuper(&superClazz, _cmd, newValue);
    
    // 4、获取观察者列表，遍历找出对应的观察者，执行响应的block
    NSMutableArray *observers = objc_getAssociatedObject(self, &QKVOAssicationKey);
    for (NSDictionary *info in observers) {
        if ([info[@"key"] isEqualToString:getterName]) {
            // gcd异步调用handler
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ((QKVOBlock)info[@"handle"])(info[@"observer"], getterName, oldValue, [NSNumber numberWithBool:newValue]);
            });
        }
    }
}

//重写的class方法的IMP
static Class QKVO_Class(id self){
    return class_getSuperclass(object_getClass(self));
}

//返回设置set方法名
static NSString *setterFormGetter(NSString * getter){
    if(getter.length > 0){
        NSString *setStr = getter.capitalizedString;
//        NSString *firstStr = [getter substringToIndex:1];
//        NSString *leavnStr = [getter substringFromIndex:1];
        return [NSString stringWithFormat:@"set%@:",setStr];
    }
    return nil;
}

//返回get方法名
static NSString *getterFormSetter(NSString * setter){
    if(setter.length<=0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) return nil;
    
    NSRange range = NSMakeRange(3, setter.length-4);
    NSString *getterStr = [setter substringWithRange:range];
    NSString *firstStr = [[getterStr substringToIndex:1] lowercaseString];
    return [getterStr stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstStr];
}


// 移除观察者
- (void)q_removeObserver:(id)observer key:(NSString *)key
{
    NSMutableArray *observers = objc_getAssociatedObject(self, &QKVOAssicationKey);
    if (!observers) return;
    
    for (NSDictionary *info in observers) {
        if([info[@"key"] isEqualToString:key]) {
            [observers removeObject:info];
            break;
        }
    }
    // 如果观察者列表count为0，则修改kvo类的isa指针，指向原来的类
    if (observers.count == 0) {
        Class clazz = object_getClass(self);
        NSString *className = NSStringFromClass(clazz);
        Class oriClass =NSClassFromString([className substringFromIndex:QKVOPerfix.length]);
        object_setClass(self, oriClass);
    }
}


@end
