//
//  ChatViewCell.m
//  SocketChat
//
//  Created by zhaimengyang on 5/26/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "ChatViewCell.h"
#import "ChatViewHelper.h"
#import "macro.h"

@interface ChatViewCell ()

@property (strong, nonatomic) ChatViewHelper *helper;

@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UIView *chatTextViewContainer;
@property (strong, nonatomic) UITextView *chatTextView;

@end

static const CGFloat margin = 10;

static const CGFloat iconViewWidth = 60;
static const CGFloat iconViewHeight = 60;

@implementation ChatViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor yellowColor];
        _helper = [[ChatViewHelper alloc]init];
        
        _iconView = [[UIImageView alloc]init];
        _chatTextViewContainer = [[UIView alloc]init];
        _chatTextView = [[UITextView alloc]init];
        _chatTextView.editable = NO;
        _chatTextView.bounces = NO;
        _chatTextView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_iconView];
        [self.contentView addSubview:_chatTextViewContainer];
        [_chatTextViewContainer addSubview:_chatTextView];
    }
    
    return self;
}

- (void)setChatModel:(ChatModel *)chatModel {
    _chatModel = chatModel;
    
    CGFloat selfWidth = self.bounds.size.width;
    
    CGSize textViewSize = [self.helper sizeForTextViewWithText:chatModel.content DisplayFont:[UIFont systemFontOfSize:14]];
    
    CGFloat iconViewX;
    CGFloat iconViewY = margin;
    CGFloat chatTextViewContainerX;
    CGFloat chatTextViewContainerY = margin;;
    CGFloat chatTextViewContainerWidth = textViewSize.width;
    CGFloat chatTextViewContainerHeight = textViewSize.height;
    
    UIImage *image;
    
    switch (chatModel.messageDirection) {
        case ChatMessageDirectionOther:
        {
            iconViewX = margin;
            chatTextViewContainerX = iconViewX + iconViewWidth + margin;
            image = [UIImage imageNamed:@"0"];
            
        }
            break;
        case ChatMessageDirectionSelf:
        {
            iconViewX = selfWidth - margin - iconViewWidth;
            chatTextViewContainerX = 0;
            image = [UIImage imageNamed:@"1"];
        }
            break;
            
        default:
            iconViewX = CGFLOAT_MAX;
            chatTextViewContainerX = CGFLOAT_MAX;
            break;
    }
    
    self.iconView.frame = CGRectMake(iconViewX, iconViewY, iconViewWidth, iconViewHeight);
    self.iconView.image = image;
    
    self.chatTextViewContainer.frame = CGRectMake(chatTextViewContainerX, chatTextViewContainerY, chatTextViewContainerWidth, chatTextViewContainerHeight);
    self.chatTextView.frame = self.chatTextViewContainer.bounds;
    self.chatTextView.text = chatModel.content;
    self.chatTextView.font = displayFont;
}

@end
