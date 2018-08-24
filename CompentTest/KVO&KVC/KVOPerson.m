
#import "KVOPerson.h"

@interface KVOPerson()

@end

@implementation KVOPerson

- (instancetype)init
{
    self = [super init];
    if (self) {
        _friends = [NSMutableArray array];
    }
    return self;
}


/**
 如果kvc设置了空值则会报异常
 可重写该方法进行提示
 @param key
 */
- (void)setNilValueForKey:(NSString *)key{
    NSLog(@"%@ 不能设置为空nil",key);
}

@end
