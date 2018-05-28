#import "MessageSendViewController.h"
#import <objc/message.h>
#import "Person.h"


@interface MessageSendViewController ()

@end

@implementation MessageSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *person = [[Person alloc] init];
    //实例方法
    [person performSelector:@selector(sendMessage:) withObject:@"hello world!"];
    //类方法
    [[Person class] performSelector:@selector(sendMessage:) withObject:@"hello world!"];
    //相当于
//    objc_msgSend(person, @selector(sendMessage:), @"hello World");
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
