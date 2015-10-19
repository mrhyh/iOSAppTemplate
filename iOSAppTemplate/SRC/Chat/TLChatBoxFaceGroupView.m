//
//  TLChatBoxFaceGroupView.m
//  iOSAppTemplate
//
//  Created by 李伯坤 on 15/10/19.
//  Copyright © 2015年 lbk. All rights reserved.
//

#import "TLChatBoxFaceGroupView.h"

@interface TLChatBoxFaceGroupView ()

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *faceGroupViewArray;

@end

@implementation TLChatBoxFaceGroupView

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.addButton];
        [self addSubview:self.scrollView];
    }
    return self;
}

#pragma mark - Public Methods
- (void) setFaceGroupArray:(NSMutableArray *)faceGroupArray
{
    _faceGroupArray = faceGroupArray;
    float w = self.frameHeight * 1.25;
    [self.addButton setFrame:CGRectMake(0, 0, w, self.frameHeight)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(w, 6, 0.5, self.frameHeight - 12)];
    [line setBackgroundColor:DEFAULT_LINE_GRAY_COLOR];
    [self addSubview:line];
    
    [self.scrollView setFrame:CGRectMake(w + 0.5, 0, self.frameWidth - self.addButton.frameWidth, self.frameHeight)];
    [self.scrollView setContentSize:CGSizeMake(w * (faceGroupArray.count + 3), self.scrollView.frameHeight)];
    float x = 0;
    int i = 0;
    for (TLFaceGroup *group in faceGroupArray) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, w, self.frameHeight)];
        [button.imageView setContentMode:UIViewContentModeCenter];
        [button setImage:[UIImage imageNamed:group.groupImageName] forState:UIControlStateNormal];
        [button setTag:i ++];
        [button addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
        [self.faceGroupViewArray addObject:button];
        [self.scrollView addSubview:button];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(button.originX + button.frameWidth, 6, 0.5, self.frameHeight - 12)];
        [line setBackgroundColor:DEFAULT_LINE_GRAY_COLOR];
        [self.scrollView addSubview:line];
        x += button.frameWidth + 0.5;
    }
    [self buttonDown:[self.faceGroupViewArray firstObject]];
}

#pragma mark - Event Response
- (void) buttonDown:(UIButton *)sender
{
    if (sender.tag == -1) {
        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxFaceGroupViewAddButtonDown)]) {
            [_delegate chatBoxFaceGroupViewAddButtonDown];
        }
    }
    else if (sender.tag == -2) {
        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxFaceGroupViewSendButtonDown)]) {
            [_delegate chatBoxFaceGroupViewSendButtonDown];
        }
    }
    else {
        for (UIButton *button in self.faceGroupViewArray) {
            [button setBackgroundColor:[UIColor whiteColor]];
        }
        [sender setBackgroundColor:DEFAULT_CHATBOX_COLOR];
        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxFaceGroupView:didSelectedFaceGroupIndex:)]) {
            [_delegate chatBoxFaceGroupView:self didSelectedFaceGroupIndex:sender.tag];
        }
    }
    
    
}

#pragma mark - Getter
- (UIButton *) addButton
{
    if (_addButton == nil) {
        _addButton = [[UIButton alloc] init];
        _addButton.tag = -1;
        [_addButton setImage:[UIImage imageNamed:@"Card_AddIcon"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    }
    return _addButton;
}

- (UIScrollView *) scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setScrollsToTop:NO];
    }
    return _scrollView;
}

- (NSMutableArray *) faceGroupViewArray
{
    if (_faceGroupViewArray == nil) {
        _faceGroupViewArray = [[NSMutableArray alloc] init];
    }
    return _faceGroupViewArray;
}

@end