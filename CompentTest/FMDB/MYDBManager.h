//
//  MYDBManager.h
//  CompentTest
//
//  Created by qrh on 2018/3/5.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYDBManager : NSObject

+ (void)dbOpen;

+ (void)createTableSql:(NSString *)sql;

+ (void)dropTableSql:(NSString *)sql;

+ (void)insertSql:(NSString *)sql params:(NSArray *)array callBack:(void (^)(BOOL flag))block;

+ (void)deleteOrUpdateSql:(NSString *)sql params:(NSArray *)array callBack:(void (^)(BOOL flag))block;

+ (NSArray *)selectSql:(NSString *)sql;

@end
