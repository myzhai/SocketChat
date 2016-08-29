//
//  ChatModel.m
//  SocketChat
//
//  Created by zhaimengyang on 5/23/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "ChatModel.h"

@implementation ChatModel

NSString * const kMessageDirection = @"kMessageDirection";
NSString * const kSuccess = @"kSuccess";
NSString * const kContent = @"kContent";
NSString * const kDate = @"kDate";

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_messageDirection forKey:kMessageDirection];
    [aCoder encodeInteger:_success forKey:kSuccess];
    [aCoder encodeObject:_content forKey:kContent];
    [aCoder encodeObject:_date forKey:kDate];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _messageDirection = [coder decodeIntegerForKey:kMessageDirection];
        _success = [coder decodeIntegerForKey:kSuccess];
        _content = [coder decodeObjectForKey:kContent];
        _date = [coder decodeObjectForKey:kDate];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    ChatModel *copy = [[[self class]allocWithZone:zone] init];
    copy.messageDirection = self.messageDirection;
    copy.success = self.success;
    copy.content = [self.content copyWithZone:zone];
    copy.date = [self.date copyWithZone:zone];
    
    return copy;
}

@end
