//
//  ChatViewLayout.m
//  SocketChat
//
//  Created by zhaimengyang on 5/25/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "ChatViewLayout.h"
#import "ChatCollectionView.h"
#import "ChatModel.h"
#import "macro.h"

@interface ChatViewLayout ()

@end

@implementation ChatViewLayout

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self= [super initWithCoder:aDecoder]) {
        //
    }
    
    return self;
}

- (CGSize)cellSizeAtIndexPath:(NSIndexPath *)indexPath {
    ChatCollectionView *chatView = (ChatCollectionView *)self.collectionView;
    return [chatView.helper sizeForChatViewCellAtIndexPath:indexPath withTextDisplayFont:displayFont];
}

- (void)prepareLayout {
    [super prepareLayout];
}

- (CGSize)collectionViewContentSize {
    CGFloat contentWidth = self.collectionView.bounds.size.width;
    CGFloat contentHeight = 0;
    
    NSInteger count = self.collectionView.numberOfSections;
    for (NSInteger section = 0; section < count; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        CGSize cellSize = [self cellSizeAtIndexPath:indexPath];
        contentHeight += cellSize.height;
    }
    return CGSizeMake(contentWidth, contentHeight);
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    NSInteger count = self.collectionView.numberOfSections;
    for (NSInteger section = 0; section < count; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.size = [self cellSizeAtIndexPath:indexPath];
    
    CGFloat xPosition = 0;
    CGFloat yPosition = 0;
    ChatCollectionView *chatView = (ChatCollectionView *)self.collectionView;
    ChatModel *chatModel = chatView.helper.chatVC.messagesToWrite[indexPath.section];
    if (chatModel.messageDirection == ChatMessageDirectionOther) {
        xPosition = 0;
    } else if (chatModel.messageDirection == ChatMessageDirectionSelf) {
        xPosition = chatView.bounds.size.width - attributes.size.width;
    }
    for (NSInteger section = 0; section < indexPath.section; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        CGSize cellSize = [self cellSizeAtIndexPath:indexPath];
        yPosition += cellSize.height;
    }
    attributes.frame = CGRectMake(xPosition, yPosition, attributes.size.width, attributes.size.height);
    
    return attributes;
}

#pragma mark - Animated updates

- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionInsert:
                //
                break;
            case UICollectionUpdateActionDelete:
                //[];
                break;
                
            default:
                break;
        }
    }
}

@end
