//
//  MYDBManager.m
//  CompentTest
//
//  Created by qrh on 2018/3/5.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "MYDBManager.h"
#import <FMDB/FMDB.h>
#import "Student.h"

static FMDatabase *_db;
static NSString *_path;

@interface MYDBManager()

@end

@implementation MYDBManager

+(void)dbOpen{
    _path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [_path stringByAppendingPathComponent:@"mysql.sqlite"];
    _db = [FMDatabase databaseWithPath:fileName];
    if([_db open]){
        NSLog(@"数据库打开成功");
    }else{
        NSLog(@"数据库打开失败");
    }
}

+(void)createTableSql:(NSString *)sql{
    BOOL result = [_db executeUpdate:sql];
    if (result) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败");
    }
}

+ (void)dropTableSql:(NSString *)sql{
    //如果表格存在 则销毁
    //@"drop table if exists t_student"
    BOOL result = [_db executeUpdate:sql];
    if (result) {
        NSLog(@"删除表成功");
    } else {
        NSLog(@"删除表失败");
    }
}

+ (void)insertSql:(NSString *)sql params:(NSArray *)array callBack:(void (^)(BOOL flag))block{
    //此出有多种方式执行
    //BOOL result = [_db executeUpdate:@"INSERT INTO t_student (name, age, sex) VALUES (?,?,?)",name,@(age),sex];
    //BOOL result = [_db executeUpdateWithFormat:@"insert into t_student (name,age, sex) values (%@,%i,%@)",name,age,sex];
    BOOL result = [_db executeUpdate:sql withArgumentsInArray:array];
    if(block){
        block(result);
    }
}

+ (void)deleteOrUpdateSql:(NSString *)sql params:(NSArray *)array callBack:(void (^)(BOOL flag))block{
    BOOL result = [_db executeUpdate:sql withArgumentsInArray:array];
    if(block){
        block(result);
    }
}

+ (NSArray *)selectSql:(NSString *)sql{
    FMResultSet *result = [_db executeQuery:sql];
    NSMutableArray *array = [NSMutableArray array];
    while ([result next]) {
        Student *s = [[Student alloc] init];
        s.sid = [result intForColumn:@"sid"];
        s.name = [result objectForColumn:@"name"];
        s.sex = [result objectForColumn:@"sex"];
        s.age = [result intForColumn:@"age"];
        [array addObject:s];
    }
    return array;
}

@end
