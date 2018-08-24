
#import <Foundation/Foundation.h>

typedef void (^QKVOBlock)(id observer,id keyPath, id oldValue, id newValue);

@interface NSObject (QKVO)

/**
 添加观察
 */
-(void)q_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath withHandle:(QKVOBlock)handle;
/**
 移除观察
 */
-(void)q_removeObserver:(id)observer key:(NSString *)key;

@end
