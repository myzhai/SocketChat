//
//  ChatCollectionView.h
//  SocketChat
//
//  Created by zhaimengyang on 5/24/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewController.h"
#import "ChatViewHelper.h"

@interface ChatCollectionView : UICollectionView

@property (strong, nonatomic) ChatViewController *chatVC;
@property (strong, nonatomic) ChatViewHelper *helper;

@end

