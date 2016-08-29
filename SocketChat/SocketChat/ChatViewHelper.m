//
//  ChatViewHelper.m
//  SocketChat
//
//  Created by zhaimengyang on 5/24/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "ChatViewHelper.h"
#import "ChatViewController.h"
#import "ChatModel.h"
#import "ChatViewCell.h"

static const CGFloat widthMaxLimit = 200;

static const CGFloat marginVertical = 10;
static const CGFloat marginHorizontal = 10;
static const CGFloat iconWidth = 60;
static const CGFloat iconHeight = 60;

@implementation ChatViewHelper

#pragma mark - PublicMethod

- (CGSize)sizeForChatViewCellAtIndexPath:(NSIndexPath *)indexPath withTextDisplayFont:(UIFont *)font {
    NSString *text = [self.chatVC.messagesToWrite[indexPath.section] content];
    CGSize textViewSize = [self sizeForTextViewWithText:text font:font];
    CGFloat width = textViewSize.width + marginHorizontal * 2 + iconWidth;
    CGFloat height = marginVertical + MAX(textViewSize.height, iconHeight);
    return CGSizeMake(width, height);
}

- (CGSize)sizeForTextViewWithText:(NSString *)text DisplayFont:(UIFont *)font {
    return [self sizeForTextViewWithText:text font:font];
}

#pragma mark - PrivateMethod

- (CGSize)sizeForTextViewWithText:(NSString *)text font:(UIFont *)font{
    UITextView *textView = [[UITextView alloc]init];
    textView.font = font;
    textView.text = text;
    return [textView sizeThatFits:CGSizeMake(widthMaxLimit, CGFLOAT_MAX)];
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout nonnull CGPoint *)targetContentOffset {
    [_chatVC dismissKeyboard];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.chatVC.messagesToWrite.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChatModel *chatModel = self.chatVC.messagesToWrite[indexPath.section];
    ChatViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    cell.chatModel = chatModel;
    
    return cell;
}

@end
