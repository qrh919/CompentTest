//
//  NFCHelper.m
//  CompentTest
//
//  Created by qrh on 2018/2/10.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "NFCHelper.h"
#import <CoreNFC/CoreNFC.h>

@interface NFCHelper()<NFCNDEFReaderSessionDelegate>

@end

@implementation NFCHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)restartSession{
    if(@available(iOS 11.0, *)){
        NFCNDEFReaderSession *session = [[NFCNDEFReaderSession alloc] initWithDelegate:self queue:nil invalidateAfterFirstRead:YES];
        [session beginSession];//开启nfc监听
    }
}

-(void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error{
    if(self.onNFCResultBlock){
        self.onNFCResultBlock(NO, error.description);
    }
}

-(void)readerSession:(NFCNDEFReaderSession *)session didDetectNDEFs:(NSArray<NFCNDEFMessage *> *)messages{
    for (NFCNDEFMessage * message in messages) {
        NSArray<NFCNDEFPayload *>* records = message.records;
        for (NFCNDEFPayload *payload in records) {
            NSString *dataStr = [[NSString alloc] initWithData:payload.payload encoding:NSUTF8StringEncoding];
            if(self.onNFCResultBlock){
                self.onNFCResultBlock(YES, dataStr);
            }
        }
    }
}

@end
