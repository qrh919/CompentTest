#import "KVOTestViewController.h"
#import "KVOPerson.h"
#import "NSObject+QKVO.h"

@interface KVOTestViewController ()
@property (nonatomic, strong) KVOPerson *person;
@end

@implementation KVOTestViewController
//kvo 实际是观察属性的setter方法
- (void)viewDidLoad {
    [super viewDidLoad];
    _person = [[KVOPerson alloc] init];
//    //属性
//    [self.person addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:nil];
//    _person.name = @"张三";
//    //成员变量
//    [self.person addObserver:self forKeyPath:@"age" options:(NSKeyValueObservingOptionNew) context:nil];
//    self.person->age = 10;
//    //可变数组
//    [self.person addObserver:self forKeyPath:@"friends" options:(NSKeyValueObservingOptionNew) context:nil];
//    [[self.person mutableArrayValueForKeyPath:@"friends"] addObject:@"李四"];
    
    
    //自定义观察
    [self.person q_addObserver:self forKeyPath:@"name" withHandle:^(id observer, id keyPath, id oldValue, id newValue) {
        NSLog(@"%@ - %@",oldValue,newValue);
    }];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.person.name = [NSString stringWithFormat:@"张三 %d",arc4random()%100];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"%@",change);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [self.person removeObserver:self forKeyPath:@"name"];
    [self.person removeObserver:self forKeyPath:@"age"];
    [self.person removeObserver:self forKeyPath:@"friends"];
    
    [self.person q_removeObserver:self key:@"name"];
}

@end
