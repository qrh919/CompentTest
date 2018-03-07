//
//  LoadTest.m
//  CompentTest
//
//  Created by qrh on 2018/2/28.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "LoadTest.h"
#import <UIKit/UIKit.h>

////
//存入集合
//
//NoteGroup
//noteGroup = {rect, 3};
//
//[array
// addObject:[NSValue valueWithBytes:&noteGroup objCType:@encode(NoteGroup)]];
//
//
//
////
//取出
//
//NoteGroup
//noteGroup;
//
//NSValue
//*noteGroupValue = array[index];
//
//[noteGroupValue
// getValue:&noteGroup];

typedef struct loadPage{
    CGRect rect;
    int page;
} loadPage;

@interface LoadTest()
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation LoadTest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArr = [NSMutableArray array];
        loadPage page = {CGRectZero,2};
        [_dataArr addObject:[NSValue valueWithBytes:&page objCType:@encode(loadPage)]];
        
    }
    return self;
}

+(void)load{
    NSLog(@"%@",NSStringFromClass([self class]));
}

-(void)showData{
    if(_dataArr){
        NSValue *value = _dataArr[0];
        loadPage page;
        [value getValue:&page];
        NSLog(@"%d",page.page);
    }
}

@end

