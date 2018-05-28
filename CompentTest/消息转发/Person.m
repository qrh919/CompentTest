//
//  Person.m
//  CompentTest
//
//  Created by qrh on 2018/5/10.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "Person.h"
#import "Animal.h"

#import <objc/runtime.h>

@interface Person()
@property (nonatomic, strong) Animal *animal;
@end

@implementation Person

//1.静态转发 - 实例方法
+(BOOL)resolveInstanceMethod:(SEL)sel{
    NSString *selector = NSStringFromSelector(sel);
    if([selector isEqualToString:@"sendMessage:"]){
        class_addMethod([self class], sel, (IMP)sendMessage, "v@:@");
    }
    
    return NO;
}
//OC消息发送底层每个方法都会有默认的2个参数 ：id 调用者 SEL 本身
void sendMessage(id self,SEL _cmd,NSString *message){
    NSLog(@"message:%@",message);
}

//1.类方法 由于self class中只存在实例方法 所以在类方法中应该使用metaClass
+(BOOL)resolveClassMethod:(SEL)sel{
    NSString *selector = NSStringFromSelector(sel);
    if([selector isEqualToString:@"sendMessage:"]){
        Class metaClass = objc_getMetaClass(class_getName([self class]));
        class_addMethod(metaClass, sel, (IMP)sendMessage, "v@:@");
    }
    return NO;
}

//已下是实例方法的转发 类方法有对应的
//上述代码中的methodSignatureForSelector、forwardInvocation、doesNotRecognizeSelector在类方法的转发过程不会被触发，需要将前面的“-”换成“＋”才会被触发（毕竟是查找类方法，有点区别）。
//+ (void)forwardInvocation:(NSInvocation *)anInvocation {
//   TODO...
//}

//2.对象转发
-(id)forwardingTargetForSelector:(SEL)aSelector{
    NSString *selector = NSStringFromSelector(aSelector);
    if([selector isEqualToString:@"sendMessage:"]){
        Animal *animal = [[Animal alloc] init];
        return animal;
    }
    return [super forwardingTargetForSelector:aSelector];
}

//3.消息转发 1签名
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSString *selector = NSStringFromSelector(aSelector);
    if([selector isEqualToString:@"sendMessage:"]){
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    return [super methodSignatureForSelector:aSelector];
}
//2.转发
-(void)forwardInvocation:(NSInvocation *)anInvocation{
    NSString *selector = NSStringFromSelector(anInvocation.selector);
    if([selector isEqualToString:@"sendMessage:"]){
        [anInvocation invokeWithTarget:[Animal new]];
    }
}

//4.失败
-(void)doesNotRecognizeSelector:(SEL)aSelector{
    NSLog(@"doesNotRecognizeSelector %@",NSStringFromSelector(aSelector));
}


@end
