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

//1.静态转发
+(BOOL)resolveInstanceMethod:(SEL)sel{
    NSString *selector = NSStringFromSelector(sel);
    if([selector isEqualToString:@"sendMessage:"]){
        class_addMethod(self, sel, (IMP)sendMessage, "v@:@");
    }
    
    return NO;
}
void sendMessage(id self,SEL _cmd,NSString *message){
    NSLog(@"message:%@",message);
}


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
