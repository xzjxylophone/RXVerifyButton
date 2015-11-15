//
//  RXVerifyButton.h
//  A2A
//
//  Created by Rush.D.Xzj on 15-4-9.
//  Copyright (c) 2015年 Rush.D.Xzj. All rights reserved.
//

#import <UIKit/UIKit.h>





typedef enum E_RX_VerifyStatus {
    kE_RX_VerifyStatusInit           =       0, // 初始化
    kE_RX_VerifyStatusCountDown      =       1, // 倒计时
    kE_RX_VerifyStatusAgain          =       2, // 再发一次
    kE_RX_VerifyStatusOK             =       3, // OKFunc // 当填充完验证码的时候自动发送
}E_RX_VerifyStatus;



@class RXVerifyButton;

@protocol RXVerifyButtonDelegate <NSObject>

- (BOOL)sendAgainInRXVerifyButton:(RXVerifyButton *)rxVB;
- (void)okFuncInRXVerifyButton:(RXVerifyButton *)rxVB;

@end


@interface RXVerifyButton : UIButton
@property (nonatomic, assign) E_RX_VerifyStatus e_RX_VerifyStatus;
@property (nonatomic, weak) id<RXVerifyButtonDelegate> delegate;



- (void)setBtnAttributes:(NSDictionary *)attributes;



- (void)updateToLastStatues;


@end
