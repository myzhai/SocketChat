//
//  ChatViewController.h
//  SocketChat
//
//  Created by zhaimengyang on 5/23/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

//UIKIT_EXTERN int socketNumber;
UIKIT_EXTERN struct sockaddr_in serverSocket;
UIKIT_EXTERN NSString * const messagesKey;

@interface ChatViewController : UIViewController

@property (assign, nonatomic) int socketNumber;

@property (assign, nonatomic) BOOL stopRecv;

@property (readonly, nonatomic) NSArray *messagesToWrite;
- (NSString *)cacheFilePath;

- (void)dismissKeyboard;

@end
