//
//  LoginViewController.m
//  SimpleSipPhone
//
//  Created by zhanghan on 2018/2/27.
//  Copyright © 2018年 zhanghan. All rights reserved.
//

#import <pjsua-lib/pjsua.h>
#import "LoginViewController.h"
#import "DialViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *serverField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(__handleRegisterStatus:)
                                                 name:@"SIPRegisterStatusNotification"
                                               object:nil];
    
    self.title = @"注册SIP";
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)__handleRegisterStatus:(NSNotification *)notification {
    pjsua_acc_id acc_id = [notification.userInfo[@"acc_id"] intValue];
    pjsip_status_code status = [notification.userInfo[@"status"] intValue];
    NSString *statusText = notification.userInfo[@"status_text"];
    
    if (status != PJSIP_SC_OK) {
        NSLog(@"登录失败, 错误信息: %d(%@)", status, statusText);
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:acc_id forKey:@"login_account_id"];
    [[NSUserDefaults standardUserDefaults] setObject:self.serverField.text forKey:@"server_uri"];
    [[NSUserDefaults standardUserDefaults] setObject:self.usernameField.text forKey:@"user_account"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self __switchToDialViewController];
}

- (void)__switchToDialViewController {
    DialViewController *dialViewController = [[DialViewController alloc] init];
    
    CATransition *transition = [[CATransition alloc] init];
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionFade;
    transition.duration  = 0.5;
    transition.removedOnCompletion = YES;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow.layer addAnimation:transition forKey:@"change_view_controller"];
    
    keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:dialViewController];
}

- (IBAction)loginButtonTouched:(id)sender {
    if (self.serverField.text.length == 0 || self.usernameField.text.length == 0 || self.passwordField.text.length == 0) {
        NSLog(@"请正确配置信息");
    } else {
        [self registerPjSipWithServer:self.serverField.text user:self.usernameField.text password:self.passwordField.text];
    }
}

- (IBAction)login_805:(id)sender {
    self.serverField.text = @"47.97.116.134:5369";
    self.usernameField.text= @"805";
    self.passwordField.text = @"805";
}

- (IBAction)login_806:(id)sender {
    self.serverField.text = @"47.97.116.134:5369";
    self.usernameField.text= @"806";
    self.passwordField.text = @"806";
}

- (IBAction)login_1001:(id)sender {
    self.serverField.text = @"192.168.1.54:5060";
    self.usernameField.text= @"1001";
    self.passwordField.text = @"0000";
}

- (IBAction)login_1002:(id)sender {
    self.serverField.text = @"192.168.1.54:5060";
    self.usernameField.text= @"1002";
    self.passwordField.text = @"0000";
}

- (void)registerPjSipWithServer:(NSString *)server user:(NSString *)username password:(NSString *)password {
    pjsua_acc_id acc_id;
    pjsua_acc_config cfg;
    
    pjsua_acc_config_default(&cfg);
    cfg.id = pj_str((char *)[NSString stringWithFormat:@"sip:%@@%@", username, server].UTF8String);
    cfg.reg_uri = pj_str((char *)[NSString stringWithFormat:@"sip:%@", server].UTF8String);
    cfg.reg_retry_interval = 0;
    cfg.cred_count = 1;
    cfg.cred_info[0].realm = pj_str("*");
    cfg.cred_info[0].username = pj_str((char *)username.UTF8String);
    cfg.cred_info[0].data_type = PJSIP_CRED_DATA_PLAIN_PASSWD;
    cfg.cred_info[0].data = pj_str((char *)password.UTF8String);
    
    pj_status_t status = pjsua_acc_add(&cfg, PJ_TRUE, &acc_id);
    
    if (status != PJ_SUCCESS) {
        NSString *errorMessage = [NSString stringWithFormat:@"登录失败, 返回错误号:%d!", status];
        NSLog(@"register error: %@", errorMessage);
    }
}

- (IBAction)clearAllInput:(id)sender {
    self.serverField.text = @"";
    self.usernameField.text= @"";
    self.passwordField.text = @"";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.serverField isFirstResponder]) {
        [self.serverField resignFirstResponder];
    }
    if ([self.usernameField isFirstResponder]) {
        [self.usernameField resignFirstResponder];
    }
    if ([self.passwordField isFirstResponder]) {
        [self.passwordField resignFirstResponder];
    }
}
@end
