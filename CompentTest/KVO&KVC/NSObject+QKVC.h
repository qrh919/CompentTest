
#import <Foundation/Foundation.h>
//实现基础的取值和设值
@interface NSObject (QKVC)

-(void)setQValue:(id)value forKey:(NSString *)key;
-(id)qValueForKey:(NSString *)key;

@end
