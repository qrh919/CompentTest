
#import <Foundation/Foundation.h>

@interface KVOPerson : NSObject
{
@public;
    NSInteger age;
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *friends;

@end


