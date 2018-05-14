#import "MessageSendViewController.h"
#import "Person.h"

@interface MessageSendViewController ()

@end

@implementation MessageSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *person = [[Person alloc] init];
    [person sendMessage:@"hello world!"];
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
