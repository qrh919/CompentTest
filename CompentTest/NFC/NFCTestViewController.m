//
//  NFCTestViewController.m
//  CompentTest
//
//  Created by qrh on 2018/2/8.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "NFCTestViewController.h"
#import <CoreNFC/CoreNFC.h>

@interface NFCTestViewController ()<NFCNDEFReaderSessionDelegate>

@end

@implementation NFCTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    /* 开启session
    1、当invalidateAfterFirstRead为YES时表示会在读取到第一个Tag时自动结束session，否则会话会持续。
     */
    if(@available(iOS 11.0, *)){
        NFCNDEFReaderSession *session = [[NFCNDEFReaderSession alloc] initWithDelegate:self queue:nil invalidateAfterFirstRead:YES];
//        if([NFCNDEFReaderSession readingAvailable]){//如果支持NFC读
            [session beginSession];//开启nfc监听
//        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error
{
    NSLog(@"发生错误：%@",error.description);
}

- (void)readerSession:(NFCNDEFReaderSession *)session didDetectNDEFs:(NSArray<NFCNDEFMessage *> *)messages
{
    NSLog(@"成功获取数据：%@",messages);
    for (NFCNDEFMessage * message in messages) {
        NSArray<NFCNDEFPayload *>* records = message.records;
        for (NFCNDEFPayload *payload in records) {
            NSString *dataStr = [[NSString alloc] initWithData:payload.payload encoding:NSUTF8StringEncoding];
            NSLog(@"%@",dataStr);
        }
    }
}

@end
