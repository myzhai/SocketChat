//
//  ChatViewHelper.h
//  SocketChat
//
//  Created by zhaimengyang on 5/24/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kCellReuseIdentifier @"CellReuseIdentifier"

@class ChatViewController;
@interface ChatViewHelper : NSObject <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) ChatViewController *chatVC;

- (CGSize)sizeForChatViewCellAtIndexPath:(NSIndexPath *)indexPath withTextDisplayFont:(UIFont *)font;
- (CGSize)sizeForTextViewWithText:(NSString *)text DisplayFont:(UIFont *)font;

@end
