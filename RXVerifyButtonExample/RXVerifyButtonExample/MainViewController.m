//
//  MainViewController.m
//  RXVerifyButtonExample
//
//  Created by Rush.D.Xzj on 15/11/15.
//  Copyright © 2015年 Rush.D.Xzj. All rights reserved.
//

#import "MainViewController.h"
#import "RXVerifyButton.h"
@interface MainViewController ()<RXVerifyButtonDelegate>
@property (weak, nonatomic) IBOutlet RXVerifyButton *btnDefault;
@property (weak, nonatomic) IBOutlet RXVerifyButton *btnCustom;

@end

@implementation MainViewController
#pragma mark - RXVerifyButtonDelegate

- (BOOL)sendAgainInRXVerifyButton:(RXVerifyButton *)rxVB
{
    NSLog(@"发送!");
    return YES;
}

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.btnDefault.delegate = self;
    
    self.btnCustom.delegate = self;
    NSDictionary *attributes = @{kRXVBInitBtnTextAttributeName:@"测试获取验证码",
                                 kRXVBCountDownTextFormatAttributeName:@"%zds测试",
                                 kRXVBAgainBtnTextAttributeName:@"测试再发一次"};
    self.btnDefault.backgroundColor = [UIColor redColor];
    self.btnDefault.textLabel.backgroundColor = [UIColor greenColor];
    [self.btnCustom setBtnAttributes:attributes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
