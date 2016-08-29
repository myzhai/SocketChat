//
//  ChatViewController.m
//  SocketChat
//
//  Created by zhaimengyang on 5/23/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatModel.h"
#import "ChatCollectionView.h"
#import "ChatViewHelper.h"

@interface ChatViewController () <UITextViewDelegate>

@property (assign, nonatomic) BOOL shouldBreak;
@property (strong, nonatomic) NSMutableArray *messages;

@property (weak, nonatomic) IBOutlet UIView *inputContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputContainerBottomLayout;

@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (assign, nonatomic) BOOL registerObserver;

@property (weak, nonatomic) IBOutlet ChatCollectionView *ChatView;

@end

static const CGFloat inputContainerDefaultHeight = 33;
static NSString * const RecieveMessageNotification = @"RecieveMessageNotification";

@implementation ChatViewController
{
    uint8_t buffer[1024];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _shouldBreak = NO;
    _messages = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:[self cacheFilePath]]];
    NSLog(@"%@", _messages);
    self.registerObserver = NO;
    self.inputTextView.delegate = self;
    self.ChatView.chatVC = self;
    
    [self addGesture];
    [self addObserver];
    [self beginReceiveMessage];
}

#pragma mark - PublicMethod

- (NSString *)cacheFilePath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"cache.ca"];
}

- (void)dismissKeyboard {
    if ([self.inputTextView isFirstResponder]) {
        [self.inputTextView resignFirstResponder];
    }
}

#pragma mark - ActionMethod

- (void)swipeDown:(UISwipeGestureRecognizer *)gestureRecognizer {
    [self dismissKeyboard];
}

- (IBAction)sendMessage:(UIButton *)sender {
    if (self.inputTextView.text.length <= 0) {
        return;
    }
    NSString *messageString = self.inputTextView.text;
    ssize_t len = send(self.socketNumber, messageString.UTF8String, strlen(messageString.UTF8String), 0);
    
    ChatModel *model = [[ChatModel alloc]init];
    model.messageDirection = ChatMessageDirectionSelf;
    model.success = NO;
    model.content = messageString;
    model.date = [NSDate date];
    if (len > 0) {
        model.success = YES;
    }
    [self updateForAddingModel:model];
    
    self.inputTextView.text = @"";
}

#pragma mark - PrivateMethod

- (void)addGesture {
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    swipeGR.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGR];
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter]addObserverForName:RecieveMessageNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        ChatModel *model = note.userInfo[@"key"];
        [self updateForAddingModel:model];
    }];
}

- (void)beginReceiveMessage {
    dispatch_async(dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT), ^{
        [self receiveMessage];
    });
}

- (void)updateForAddingModel:(ChatModel *)model {
    [self.messages addObject:model];
    [self.ChatView insertSections:[NSIndexSet indexSetWithIndex:self.messages.count-1]];
    [self scrollToVisible];
}

- (void)receiveMessage {
    if (_shouldBreak) {
        return;
    }
    ssize_t len = recv(self.socketNumber, buffer, sizeof(buffer), 0);
    if (len > 0) {
        NSData *data = [NSData dataWithBytes:buffer length:len];
        NSString *recvMsg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        ChatModel *model = [[ChatModel alloc]init];
        model.messageDirection = ChatMessageDirectionOther;
        model.content = recvMsg;
        model.date = [NSDate date];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:RecieveMessageNotification object:nil userInfo:[NSDictionary dictionaryWithObject:model forKey:@"key"]];
        
        NSLog(@"%@", recvMsg);
        [self receiveMessage];
    }
}

- (void)registerObserverForUIKeyboard {
    if (!self.registerObserver) {
        self.registerObserver = YES;
        [[NSNotificationCenter defaultCenter]
         addObserverForName:UIKeyboardWillChangeFrameNotification
         object:nil
         queue:[NSOperationQueue mainQueue]
         usingBlock:^(NSNotification * _Nonnull note) {
             NSDictionary *info = note.userInfo;
             CGFloat beginY = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].origin.y;
             CGFloat endY = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
             self.inputContainerBottomLayout.constant += beginY - endY;
             [UIView animateWithDuration:UIKeyboardAnimationDurationUserInfoKey.doubleValue animations:^{
                 [self.view layoutIfNeeded];
             }];
         }];
    }
}

- (void)updateInputContainer {
    CGFloat contentHeight = self.inputTextView.contentSize.height;
    self.inputContainerHeight.constant = contentHeight <= 200 ? contentHeight : 200;
    [UIView animateWithDuration:UIKeyboardAnimationDurationUserInfoKey.doubleValue animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self scrollToVisible];
    }];
}

- (void)scrollToVisible {
    [self.ChatView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:self.ChatView.numberOfSections - 1] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.inputTextView.contentInset = UIEdgeInsetsZero;
    self.inputTextView.scrollIndicatorInsets = UIEdgeInsetsZero;
    [self registerObserverForUIKeyboard];
    [self updateInputContainer];
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    self.inputContainerHeight.constant = inputContainerDefaultHeight;
    [self.inputContainer layoutIfNeeded];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self updateInputContainer];
}

#pragma mark - Setter and Getter

- (void)setStopRecv:(BOOL)stopRecv {
    _stopRecv = stopRecv;
    
    _shouldBreak = stopRecv;
}

- (NSArray *)messagesToWrite {
    return [_messages copy];
}

@end
