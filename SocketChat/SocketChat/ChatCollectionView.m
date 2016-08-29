//
//  ChatCollectionView.m
//  SocketChat
//
//  Created by zhaimengyang on 5/24/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "ChatCollectionView.h"
#import "ChatViewCell.h"

@implementation ChatCollectionView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self registerClass:[ChatViewCell class] forCellWithReuseIdentifier:kCellReuseIdentifier];
        
        _helper = [[ChatViewHelper alloc]init];
        self.delegate = _helper;
        self.dataSource = _helper;
    }
    
    return self;
}

- (void)setChatVC:(ChatViewController *)chatVC {
    _chatVC = chatVC;
    if (!_helper.chatVC) {
        _helper.chatVC = _chatVC;
    }
}

@end
