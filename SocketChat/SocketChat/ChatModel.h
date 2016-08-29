//
//  ChatModel.h
//  SocketChat
//
//  Created by zhaimengyang on 5/23/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ChatMessageDirection) {
    ChatMessageDirectionSystem,
    ChatMessageDirectionSelf,
    ChatMessageDirectionOther,
};

@interface ChatModel : NSObject <NSCoding, NSCopying>

@property (assign, nonatomic) ChatMessageDirection messageDirection;
@property (assign, nonatomic) BOOL success;
@property (copy, nonatomic) NSString *content;
@property (strong, nonatomic) NSDate *date;

@end
