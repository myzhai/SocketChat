//
//  ViewController.m
//  SocketChat
//
//  Created by zhaimengyang on 5/23/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "ViewController.h"
#import "ChatViewController.h"

@interface ViewController () <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *IPAddressField;
@property (assign, nonatomic) BOOL connected;
@property (assign, nonatomic) int socketNumber;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    swipeGR.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGR];
    
    self.navigationController.delegate = self;
    _connected = NO;
}

- (void)swipeDown:(UISwipeGestureRecognizer *)gestureRecognizer {
    [self dismissKeyboard];
}

- (void)dismissKeyboard {
    if ([self.IPAddressField isFirstResponder]) {
        [self.IPAddressField resignFirstResponder];
    }
}

- (IBAction)startChatting:(UIButton *)sender {
    [self dismissKeyboard];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ChatViewController *chatVC = (ChatViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"ChatVC"];
//    ChatViewController *chatVC = [[ChatViewController alloc]init];
    
    chatVC.socketNumber = socket(AF_INET, SOCK_STREAM, 0);
    self.socketNumber = chatVC.socketNumber;
    if (chatVC.socketNumber > 0) {
        NSLog(@"socketNumber = %d created successfully", chatVC.socketNumber);
    } else {
        NSLog(@"socketNumber = %d created Unsuccessfully", chatVC.socketNumber);
        return;
    }
    
    struct sockaddr_in serverSocket;
    serverSocket.sin_family = AF_INET;
    serverSocket.sin_addr.s_addr = inet_addr(self.IPAddressField.text.UTF8String);
    serverSocket.sin_port = htons(12345);
    
    int isConnected = connect(chatVC.socketNumber, (struct sockaddr *)&serverSocket, sizeof(serverSocket));
    if (!isConnected) {
        NSLog(@"isConnected = %d Connected", isConnected);
        _connected = YES;
        [self.navigationController pushViewController:chatVC animated:YES];
    } else {
        NSLog(@"isConnected = %d Can not connect", isConnected);
        return;
    }
}

#pragma mark - UINavigationControllerDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(nonnull UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPop && toVC == self) {
        if (_connected) {
            close(self.socketNumber);
        }
        if ([fromVC isKindOfClass:[ChatViewController class]]) {
            ChatViewController *from = (ChatViewController *)fromVC;
            [[NSNotificationCenter defaultCenter]removeObserver:from name:UIKeyboardWillChangeFrameNotification object:nil];
            from.stopRecv = YES;
            [NSKeyedArchiver archiveRootObject:from.messagesToWrite toFile:[from cacheFilePath]];
        }
    }
    
    return nil;
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    NSLog(@"will-->%@", navigationController.viewControllers);
//}
//
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    NSLog(@"did-->%@", navigationController.viewControllers);
//    if (viewController == self && _connected) {
//        close(self.socketNumber);
//    }
//}

@end
