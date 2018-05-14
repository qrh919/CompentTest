//
//  QFileDLMananger.m
//  CompentTest
//
//  Created by qrh on 2018/3/9.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "QFileDLMananger.h"

#define kFileName @"test.mp4"

typedef void (^completRate) (CGFloat rate);

@interface QFileDLMananger()<NSURLSessionDataDelegate>

@property (nonatomic, assign) NSInteger currentSize;
@property (nonatomic, assign) NSInteger totalSize;

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSOutputStream *outPutStream;

@property (nonatomic, copy) completRate completeBlock;

@end

@implementation QFileDLMananger

-(instancetype)initWithURL:(NSString *)urlString{
    if (self = [super init]) {
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        self.currentSize = [self cacheSize];
        
        //设置请求头
        NSString *header = [NSString stringWithFormat:@"bytes %zd-",self.currentSize];
        
        [request setValue:header forHTTPHeaderField:@"Range"];
        self.dataTask = [session dataTaskWithRequest:request];
        [self.dataTask resume];
    }
    return self;
}
//启动
-(void)resume{
    NSParameterAssert(self.dataTask);
    [self.dataTask resume];
}
//停止
-(void)suspend{
    NSParameterAssert(self.dataTask);
    [self.dataTask suspend];
}

-(NSInteger)cacheSize{
    //缓存文件路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kFileName];
    //取出沙盒文件大小
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSInteger size = [[dic objectForKey:@"NSFileSize"] integerValue];
    return size;
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    //允许继续执行
    completionHandler(NSURLSessionResponseAllow);
    
    self.totalSize = response.expectedContentLength + self.currentSize;
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kFileName];
    NSLog(@"path=%@",path);
    
    //创建输出流
    NSOutputStream *outstream = [NSOutputStream outputStreamToFileAtPath:path append:YES];
    [outstream open];
    self.outPutStream = outstream;
}
//接受服务端返回的数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    self.currentSize += data.length;
    //完成的进度
    CGFloat rate = 1.0 * (self.currentSize/self.totalSize);
    if(self.completeBlock){
        self.completeBlock(rate);
    }
    //写入文件
    [self.outPutStream write:data.bytes maxLength:data.length];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    [self.outPutStream close];
    self.outPutStream = nil;
}

+ (void)downloadWithURL:(NSString *)urlString withProgress:(void (^)(CGFloat))progress{
    
    QFileDLMananger *manager = [[QFileDLMananger alloc] initWithURL:urlString];
    manager.completeBlock = ^(CGFloat rate) {
        if(progress){
            progress(rate);
        }
    };
    
}

@end
