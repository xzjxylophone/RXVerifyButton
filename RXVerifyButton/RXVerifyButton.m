//
//  RXVerifyButton.m
//  A2A
//
//  Created by Rush.D.Xzj on 15-4-9.
//  Copyright (c) 2015年 Rush.D.Xzj. All rights reserved.
//

#import "RXVerifyButton.h"


@interface RXVerifyButton ()



@property (nonatomic, strong) UILabel *lblShow;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int usedTime; // 花费的时间
@property (nonatomic, assign) int maxTime;
@property (nonatomic, assign) E_RX_VerifyStatus last_E_RX_VerifyStatus;



@property (nonatomic, copy) NSString *initalizationBtnTitle; // 初始化的时候按钮的文案
@property (nonatomic, copy) NSString *okBtnTitle;   // 设置OK的时候的按钮的文案
@property (nonatomic, copy) NSString *againBtnTitle; // 再发一次的按钮的文案
@property (nonatomic, copy) NSString *formatShowString; // 倒计时 label 显示的, default format  %ds
@property (nonatomic, copy) NSString *showLabelTextColor; // 倒计时的label的字体颜色啊






@end


@implementation RXVerifyButton


- (void)setBtnAttributes:(NSDictionary *)attributes
{
    
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
        case kE_RX_VerifyStatusOK:
        case kE_RX_VerifyStatusInit:
        default:
            // 目前应该不会出现此状况
            break;
    }
}

- (void)setE_RX_VerifyStatus:(E_RX_VerifyStatus)e_RX_VerifyStatus
{
    self.last_E_RX_VerifyStatus = self.e_RX_VerifyStatus;
    _e_RX_VerifyStatus = e_RX_VerifyStatus;
    switch (e_RX_VerifyStatus) {
        case kE_RX_VerifyStatusInit:
        {
            [self.lblShow removeFromSuperview];
            self.lblShow.text = @"";
            [self setTitle:@"获取验证码" forState:UIControlStateNormal];
            self.enabled = YES;
        }
            break;
        case kE_RX_VerifyStatusCountDown:
        {
            [self addSubview:self.lblShow];
            [self setTitle:@"" forState:UIControlStateNormal];
            NSString *text = [NSString stringWithFormat:@"%ds", self.maxTime];
            self.lblShow.text = text;
#warning 添加全部
            self.enabled = NO;
            [self startTimer];
        }
            break;
        case kE_RX_VerifyStatusAgain:
        {
            [self.lblShow removeFromSuperview];
            [self setTitle:@"再发一次" forState:UIControlStateNormal];
            self.enabled = YES;
        }
            break;
        case kE_RX_VerifyStatusOK:
        {
            [self.lblShow removeFromSuperview];
            [self setTitle:@"确定" forState:UIControlStateNormal];
            self.enabled = YES;
        }
            break;
        default:
            break;
    }
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
            }
        }
            break;
        case kE_RX_VerifyStatusCountDown:
            // 几乎不可能
            // 在倒计时的状态的时候,是不可以点击此按钮的
            break;
        case kE_RX_VerifyStatusOK:
        default:
            [self.delegate okFuncInRXVerifyButton:self];
            break;
    }
}


- (void)timerAction:(id)sender
{
    int remainTime = self.maxTime - self.usedTime;
    if (remainTime == 0) {
        [self stopTimer];
        self.usedTime = 0;
        switch (self.e_RX_VerifyStatus) {
            case kE_RX_VerifyStatusOK:
                // Do Nothing
                // 上一次是倒计时的话,把上一次改成再次发送
                if (self.last_E_RX_VerifyStatus == kE_RX_VerifyStatusCountDown) {
                    self.last_E_RX_VerifyStatus = kE_RX_VerifyStatusAgain;
                }
                break;
            case kE_RX_VerifyStatusCountDown:
                self.e_RX_VerifyStatus = kE_RX_VerifyStatusAgain;
                break;
            default:
                break;
        }
    } else {
        self.usedTime++;
        NSString *text = [NSString stringWithFormat:@"%ds", remainTime];
        self.lblShow.text = text;
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
    self.lblShow = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.lblShow.backgroundColor = [UIColor clearColor];
    self.lblShow.textAlignment = NSTextAlignmentCenter;
    self.lblShow.textColor = [UIColor whiteColor];
    [self addTarget:self action:@selector(btnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
#if DEBUG
    self.maxTime = 10;
#else
    self.maxTime = 60;
#endif
    self.e_RX_VerifyStatus = kE_RX_VerifyStatusInit;
}









@end
