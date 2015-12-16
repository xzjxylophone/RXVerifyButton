//
//  RXVerifyButton.m
//  A2A
//
//  Created by Rush.D.Xzj on 15-4-9.
//  Copyright (c) 2015年 Rush.D.Xzj. All rights reserved.
//

#import "RXVerifyButton.h"

const NSString *kRXVBInitBtnTextAttributeName = @"kRXVBInitBtnTextAttributeName";
const NSString *kRXVBAgainBtnTextAttributeName = @"kRXVBAgainBtnTextAttributeName";
const NSString *kRXVBCountDownTextFormatAttributeName = @"kRXVBCountDownTextFormatAttributeName";




@interface RXVerifyButton ()



@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger usedTime; // 花费的时间
@property (nonatomic, assign) E_RX_VerifyStatus last_E_RX_VerifyStatus;


@property (nonatomic, strong) NSDictionary *defaultAttribute;
@property (nonatomic, strong) NSMutableDictionary *currentAttribute;

@end


@implementation RXVerifyButton


- (void)setBtnAttributes:(NSDictionary *)attributes
{
    self.currentAttribute = [NSMutableDictionary dictionaryWithDictionary:self.defaultAttribute];

    for (NSString *key in attributes.allKeys) {
        [self.currentAttribute setValue:attributes[key] forKey:key];
    }
    
    
    [self updateRelateText];
}

- (void)updateToLastStatues
{
    switch (self.last_E_RX_VerifyStatus) {
        case kE_RX_VerifyStatusAgain:
            self.e_RX_VerifyStatus = kE_RX_VerifyStatusAgain;
            return;
        case kE_RX_VerifyStatusCountDown:
            if (self.timer == nil) {
                self.e_RX_VerifyStatus = kE_RX_VerifyStatusAgain;
            } else {
                self.e_RX_VerifyStatus = kE_RX_VerifyStatusCountDown;
            }
            break;
        case kE_RX_VerifyStatusInit:
        default:
            // 目前应该不会出现此状况
            break;
    }
}

#pragma mark - Proverty
- (void)setE_RX_VerifyStatus:(E_RX_VerifyStatus)e_RX_VerifyStatus
{
    self.last_E_RX_VerifyStatus = self.e_RX_VerifyStatus;
    _e_RX_VerifyStatus = e_RX_VerifyStatus;
    switch (e_RX_VerifyStatus) {
        case kE_RX_VerifyStatusInit:
        {
            [self.textLabel removeFromSuperview];
            self.enabled = YES;
        }
            break;
        case kE_RX_VerifyStatusCountDown:
        {
            self.usedTime = 1;
            self.enabled = NO;
            [self addSubview:self.textLabel];
            [self fillAllInSuperView:self subView:self.textLabel];
            [self startTimer];
        }
            break;
        case kE_RX_VerifyStatusAgain:
        {
            [self.textLabel removeFromSuperview];
            self.enabled = YES;
        }
            break;
        default:
            break;
    }
    [self updateRelateText];
}

#pragma mark - Private
- (void)updateRelateText
{
    switch (self.e_RX_VerifyStatus) {
        case kE_RX_VerifyStatusInit:
        {
            NSString *text = self.currentAttribute[kRXVBInitBtnTextAttributeName];
            self.textLabel.text = @"";
            [self setTitle:text forState:UIControlStateNormal];
        }
            break;
        case kE_RX_VerifyStatusCountDown:
        {
            [self setTitle:@"" forState:UIControlStateNormal];
            [self updateTextWithRemainTime:self.maxTime];

        }
            break;
        case kE_RX_VerifyStatusAgain:
        {
            NSString *text = self.currentAttribute[kRXVBAgainBtnTextAttributeName];
            [self setTitle:text forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}
- (void)updateTextWithRemainTime:(NSUInteger)remainTime
{
    NSString *textFormat = self.currentAttribute[kRXVBCountDownTextFormatAttributeName];
    NSString *text = [NSString stringWithFormat:textFormat, remainTime];
    self.textLabel.text = text;
}

- (void)startTimer
{
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    }
}
- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)fillAllInSuperView:(UIView *)superview subView:(UIView *)subView
{
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *lc1 = [NSLayoutConstraint constraintWithItem:superview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:subView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *lc2 = [NSLayoutConstraint constraintWithItem:superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:subView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *lc3 = [NSLayoutConstraint constraintWithItem:superview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:subView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *lc4 = [NSLayoutConstraint constraintWithItem:superview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:subView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [superview addConstraints:@[lc1, lc2, lc3, lc4]];
}

#pragma mark - Action
- (void)btnTouchUpInside:(id)sender
{
    switch (self.e_RX_VerifyStatus) {
        case kE_RX_VerifyStatusInit:
        case kE_RX_VerifyStatusAgain:
        {
            BOOL result = [self.delegate sendAgainInRXVerifyButton:self];
            if (result) {
                self.e_RX_VerifyStatus = kE_RX_VerifyStatusCountDown;
            } else {
                // Do Nothing
                // 如果返回失败就do nothing
            }
        }
            break;
        case kE_RX_VerifyStatusCountDown:
            // 几乎不可能
            // 在倒计时的状态的时候,是不可以点击此按钮的
            break;
        default:
            break;
    }
}


- (void)timerAction:(id)sender
{
    NSUInteger remainTime = self.maxTime - self.usedTime;
    if (remainTime == 0) {
        [self stopTimer];
        self.usedTime = 0;
        switch (self.e_RX_VerifyStatus) {
            case kE_RX_VerifyStatusCountDown:
                self.e_RX_VerifyStatus = kE_RX_VerifyStatusAgain;
                break;
            default:
                break;
        }
    } else {
        self.usedTime++;
        [self updateTextWithRemainTime:remainTime];
    }
}

#pragma mark - Override

- (void)awakeFromNib
{
    [self initialize];
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.textColor = [UIColor blackColor];
    [self addTarget:self action:@selector(btnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSDictionary *defaultDic = @{kRXVBInitBtnTextAttributeName:@"获取验证码",
                                 kRXVBAgainBtnTextAttributeName:@"再发一次",
                                 kRXVBCountDownTextFormatAttributeName:@"%zds"};
    self.defaultAttribute = defaultDic;
    self.currentAttribute = [NSMutableDictionary dictionaryWithDictionary:defaultDic];
    
#if DEBUG
    self.maxTime = 10;
#else
    self.maxTime = 60;
#endif
    self.e_RX_VerifyStatus = kE_RX_VerifyStatusInit;
}









@end
