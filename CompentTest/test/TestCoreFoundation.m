//
//  TestCoreFoundation.m
//  CompentTest
//
//  Created by qrh on 2018/3/2.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "TestCoreFoundation.h"
#import <CoreFoundation/CoreFoundation.h>

@implementation TestCoreFoundation

-(void)test1{
    CFStringRef cstr = CFSTR("hellowrold");
    CFShow(cstr);
    
    CFArrayRef arr = CFArrayCreate(NULL, (const void **)cstr, 1, &kCFTypeArrayCallBacks);
    CFShow(arr);
    
    CFShowStr(cstr);
    
    //
    const char *charset = "hello c";
    CFStringRef str = CFStringCreateWithCString(NULL, charset, kCFStringEncodingUTF8);
    CFShow(str);
    CFRelease(str);
}

-(void)test2{
    /*********************** 字符串复制 ***********************/
    /** 一般缓冲区的字符串会继续使用，所以需要复制到新的CFString中 **/
    
    /***** 方式一 ******/
    {
        /**
         * 复制字符串
         * NoCopy 不会创建新的内存空间，节省内存，提高效率；
         * string5 持有缓冲区，所以由 string5 来释放内存；
         **/
        const char *cstr = "How are you!";
        char *bytes = malloc(strlen(cstr) + 1);
        strcpy(bytes, cstr);//cstr 拷贝到 bytes 数组
        
        //传入 kCFAllocatorMalloc 负责销毁 bytes 缓冲区，无需自己手动释放 bytes 缓冲区；
        CFStringRef string5 = CFStringCreateWithCStringNoCopy(NULL, bytes, kCFStringEncodingUTF8, kCFAllocatorMalloc);
        CFShow(string5);
        CFRelease(string5);
        
        //这里会输出 0
        NSLog(@"%lu", strlen(bytes));
    }
    
    /*****  方式二 ******/
    {
        /**
         * 复制字符串
         * NoCopy 不会创建新的内存空间，节省内存，提高效率；
         * string5 持有缓冲区，所以由 string5 来释放内存；
         **/
        const char *cstr = "How are you!";
        char *bytes = malloc(strlen(cstr) + 1);
        strcpy(bytes, cstr);//cstr 拷贝到 bytes 数组
        //传入 kCFAllocatorNull ， 不进行销毁 bytes 缓冲区，但要自己手动释放 bytes 缓冲区
        CFStringRef string5 = CFStringCreateWithCStringNoCopy(NULL, bytes, kCFStringEncodingUTF8, kCFAllocatorNull);
        CFShow(string5);
        CFRelease(string5);
        
        //这里会输出 12 ；
        NSLog(@"%lu", strlen(bytes));
        
    }

}

-(void)test3{
    
    {
        //创建 数组， 并允许存入 NULL 值；
        //如果需要存放 NULL 值，则用 kCFNull 常量来代替；
        
        CFArrayCallBacks callBacks = kCFTypeArrayCallBacks;
        // 设置为NULL ,意味着允许数组可以放入NULL 值；如果不设置 NULL ，放入 NULL值会崩溃；
        callBacks.retain =NULL;
        callBacks.release= NULL;
        CFMutableArrayRef array =  CFArrayCreateMutable(NULL, 0, &callBacks);
        CFStringRef string = CFStringCreateWithCString(NULL, "stuff", kCFStringEncodingUTF8);
        CFArrayAppendValue(array, string);
        CFShow(array);
        CFRelease(array);
        CFRelease(string);
    }
    
    
    {
        
        CFMutableDictionaryRef dict = CFDictionaryCreateMutable(NULL, 0, NULL, &kCFTypeDictionaryValueCallBacks);
        CFDictionarySetValue(dict, NULL, CFSTR("Foo"));
        
        const void *value;
        // 给定一个 key ，看是否存在；
        Boolean fooPresent0 = CFDictionaryGetValueIfPresent(dict, NULL, &value);// 这个是存在的
        Boolean fooPresent1 = CFDictionaryGetValueIfPresent(dict, CFSTR("888"), &value);//这个是不存在的
        
        printf("fooPresent: %d\n", fooPresent0);
        printf("fooPresent: %d\n", fooPresent1);
        
        // printf("values equal: %d\n", CFEqual(value, CFSTR("Foo")));
        
        CFRelease(dict);
        
    }
}

-(void)test4{
    {
        /*******  自由桥连接  ************/
        
        //把 oc 对象转成 C 对象；
        NSArray *arr = [NSArray arrayWithObjects:@"test", nil];
        NSLog(@"-----%ld",CFArrayGetCount((__bridge CFArrayRef)arr));
        
        //把 C 对象转成 oc 对象；
        CFMutableArrayRef cfArray = CFArrayCreateMutable(NULL, 0, &kCFTypeArrayCallBacks);
        CFArrayAppendValue(cfArray, CFSTR("HELLO"));
        NSUInteger count = [(__bridge id)cfArray count];
        printf("count=  %lu  \n", (unsigned long)count);
        CFRelease(cfArray);
        
        
        
        CFStringRef cfString = CFStringCreateWithCString(NULL, "WO CA", kCFStringEncodingUTF8);
        
        //把c 转成 oc 对象，并释放cfstring的所有权， 教给了 arc来引用；
        //并且把引用计数 -1，来平衡 CFStringCreateWithCString；
        NSString *ocStr = CFBridgingRelease(cfString);
        NSLog(@"-----ocStr:%@",ocStr);
        
        //oc 转 c
        NSString *nsString = [[NSString alloc]initWithFormat:@"NICE"];
        CFStringRef cString = CFBridgingRetain([nsString copy]);
        nsString = nil;
        
        CFShow(cString);
        CFRelease(cString);
        
    }
}

@end
