//
//  NSObject+QKVC.m
//  CompentTest
//
//  Created by qrh
//

#import "NSObject+QKVC.h"
#import <objc/runtime.h>

@implementation NSObject (QKVC)

-(void)setQValue:(id)value forKey:(NSString *)key{
    if(key == nil || key.length == 0){
        return;
    }
    if([value isKindOfClass:[NSNull class]]){
        [self setNilValueForKey:key];
        return;
    }
    if(![value isKindOfClass:[NSObject class]]){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"只支持NSObject对象类型属性" userInfo:nil];
        return;
    }
    //如果该对象实现了set方法则直接调用
    NSString *fname = [NSString stringWithFormat:@"set%@",key.capitalizedString];
    if([self respondsToSelector:NSSelectorFromString(fname)]){
        [self performSelector:NSSelectorFromString(fname) withObject:value];
        return;
    }
    
    //如果没有则去遍历当前对象的所以属性列表
    unsigned int count;
    BOOL flag = false;
    Ivar *vars = class_copyIvarList([self class], &count);
    for (int i = 0; i<count; i++) {
        Ivar var = vars[i];
        NSString *keyName = [[NSString stringWithCString:ivar_getName(var) encoding:NSUTF8StringEncoding] substringFromIndex:1];
        
        if([keyName isEqualToString:[NSString stringWithFormat:@"_%@",key]]){
            flag = true;
            object_setIvar(self, var, value);
            break;
        }
        if([keyName isEqualToString:key]){
            flag = true;
            object_setIvar(self, var, value);
            break;
        }
        //未找到属性
        if(!flag){
            [self setValue:value forUndefinedKey:key];
        }
    }
    free(vars);
}

-(id)qValueForKey:(NSString *)key{
    if(key == nil || key.length == 0){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"key 不能为空" userInfo:nil];
        return [NSNull new];
    }
    NSString *fname = [NSString stringWithFormat:@"%@",key];
    if([self respondsToSelector:NSSelectorFromString(fname)]){
        return [self performSelector:NSSelectorFromString(fname)];
    }
    //如果没有则去遍历当前对象的所以属性列表
    unsigned int count;
    BOOL flag = false;
    Ivar *vars = class_copyIvarList([self class], &count);
    for (int i = 0; i<count; i++) {
        Ivar var = vars[i];
        NSString *keyName = [[NSString stringWithCString:ivar_getName(var) encoding:NSUTF8StringEncoding] substringFromIndex:1];
        
        if([keyName isEqualToString:[NSString stringWithFormat:@"_%@",key]]){
            flag = true;
            object_getIvar(self, var);
            break;
        }
        if([keyName isEqualToString:key]){
            flag = true;
            object_getIvar(self, var);
            break;
        }
        //未找到属性
        if(!flag){
            [self valueForUndefinedKey:key];
        }
    }
    free(vars);
    return [NSNull new];
}

@end
