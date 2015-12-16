//
//  RXVerifyButton.h
//  A2A
//
//  Created by Rush.D.Xzj on 15-4-9.
//  Copyright (c) 2015年 Rush.D.Xzj. All rights reserved.
//

#import <UIKit/UIKit.h>

// default: 获取验证码
extern const NSString *kRXVBInitBtnTextAttributeName;
// default: 再发一次
extern const NSString *kRXVBAgainBtnTextAttributeName;
// default: @"%zds"
extern const NSString *kRXVBCountDownTextFormatAttributeName;



typedef enum E_RX_VerifyStatus {
    kE_RX_VerifyStatusInit           =       0, // 初始化
    kE_RX_VerifyStatusCountDown      =       1, // 倒计时
    kE_RX_VerifyStatusAgain          =       2, // 再发一次
}E_RX_VerifyStatus;



@class RXVerifyButton;

@protocol RXVerifyButtonDelegate <NSObject>

// 再次发送一次或者是第一次发送
- (BOOL)sendAgainInRXVerifyButton:(RXVerifyButton *)rxVB;

@end


@interface RXVerifyButton : UIButton
@property (nonatomic, assign) E_RX_VerifyStatus e_RX_VerifyStatus;
@property (nonatomic, weak) id<RXVerifyButtonDelegate> delegate;



// 在debug模式默认是10秒,在release模式默认是60秒,
@property (nonatomic, assign) NSUInteger maxTime;

// 更改这个lable的属性可以更改倒计时的样式
@property (nonatomic, strong) UILabel *textLabel;


// 更改相关文案的地方
- (void)setBtnAttributes:(NSDictionary *)attributes;


// 更新到上一次状态
- (void)updateToLastStatues;


@end
