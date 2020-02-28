//
//  AuthViewController.m
//  XBCodingRepo
//
//  Created by Xinbo Hong on 2018/3/19.
//  Copyright © 2018年 Xinbo Hong. All rights reserved.
//

#import "AuthViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "AuthManager.h"
#import <Masonry/Masonry.h>
@interface AuthViewController ()

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *accountLabel;

@property (nonatomic, strong) UIButton *authButton;

@property (nonatomic, strong) UILabel *alertLabel;

@property (nonatomic, strong) UIButton *waysButton;

@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self.view addSubview:self.avatarImageView];
    [self.view addSubview:self.accountLabel];
    [self.view addSubview:self.authButton];
    [self.view addSubview:self.alertLabel];
    [self.view addSubview:self.waysButton];
    
    [self initMasonry];
    [self setAuthManagerNotifications];
    self.avatarImageView.backgroundColor = [UIColor redColor];
    self.accountLabel.text = @"231asdjaksd";
}

#pragma mark - **************** Event response methods
- (void)localAuthenticationButtonAction:(UIButton *)sender {
    [AuthManager validateAuthSetting];
}

- (void)otherWaysLoginButtonAction:(UIButton *)sender {
    
}

- (BOOL)isFaceIDDevice {
    LAContext *context  = [[LAContext alloc] init];;
    
    if (@available(iOS 11.0, *)) {
        if ([context canEvaluatePolicy:kLAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
            switch (context.biometryType) {
                case LABiometryNone:
                    return false;
                    break;
                case LABiometryTypeTouchID:
                    return false;
                    break;
                case LABiometryTypeFaceID:
                    return true;
                    break;
                default:
                    break;
            }
        } else {
            return false;
        }
        
    } else {
        // Fallback on earlier versions
        return false;
    }

}

/****************** 授权处理方法 ******************/
- (void)setAuthManagerNotifications {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actionDidReceiveValidateTouchIDSuccess) name:kNotificationKeyValidateAuthSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actionDidReceiveValidateTouchIDNotAvailable) name:kNotificationKeyValidateAuthNotAvailable object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actionDidReceiveValidateTouchIDNotEnrolled) name:kNotificationKeyValidateAuthNotEnrolled object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actionDidReceiveValidateTouchIDAuthenticationFailed) name:kNotificationKeyValidateAuthFailed object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actionDidReceiveValidateTouchIDCancel) name:kNotificationKeyValidateAuthCancel object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actionTouchIDLockout) name:kNotificationKeyValidateAuthLocked object:nil];
}

- (void)actionDidReceiveValidateTouchIDSuccess {
    NSLog(@"%s",__func__);
}

- (void)actionDidReceiveValidateTouchIDNotAvailable {
    NSLog(@"%s",__func__);
}

- (void)actionDidReceiveValidateTouchIDNotEnrolled {
    NSLog(@"%s",__func__);
}

- (void)actionDidReceiveValidateTouchIDAuthenticationFailed {
    NSLog(@"%s",__func__);
}

- (void)actionDidReceiveValidateTouchIDCancel {
    NSLog(@"%s",__func__);
}

- (void)actionTouchIDLockout {
    NSLog(@"%s",__func__);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - **************** UIView frame / masonry methods
- (void)initMasonry {
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(76, 76));
    }];
    
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(5);
        make.bottom.equalTo(self.authButton.mas_top).offset(-50);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.authButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(76, 76));
    }];
    
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authButton.mas_bottom).offset(5);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.waysButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertLabel.mas_bottom).offset(100);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = CGRectGetHeight(self.avatarImageView.frame) / 2;
    if (![self isFaceIDDevice]) {
        self.authButton.layer.masksToBounds = YES;
        self.authButton.layer.cornerRadius = CGRectGetHeight(self.authButton.frame) / 2;
    }
    
    
}
#pragma mark - **************** Getter and setter
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        self.avatarImageView = [[UIImageView alloc] init];
    }
    return _avatarImageView;
}

- (UILabel *)accountLabel {
    if (!_accountLabel) {
        self.accountLabel = [[UILabel alloc] init];
        self.accountLabel.textAlignment = NSTextAlignmentCenter;
        self.accountLabel.textColor = [UIColor blackColor];
        self.accountLabel.font = [UIFont systemFontOfSize:20];
    }
    return _accountLabel;
}

- (UIButton *)authButton {
    if (!_authButton) {
        self.authButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
        if ([self isFaceIDDevice]) {
            [self.authButton setImage:[UIImage imageNamed:@"auth_icon_face"] forState:UIControlStateNormal];
        } else {
            [self.authButton setImage:[UIImage imageNamed:@"auth_icon_touch"] forState:UIControlStateNormal];
        }
        [self.authButton addTarget:self action:@selector(localAuthenticationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _authButton;
}

- (UILabel *)alertLabel {
    if (!_alertLabel) {
        self.alertLabel = [[UILabel alloc] init];
        self.alertLabel.textAlignment = NSTextAlignmentCenter;
        self.alertLabel.textColor = [UIColor blackColor];
        self.alertLabel.font = [UIFont systemFontOfSize:15];
        if ([self isFaceIDDevice]) {
            self.alertLabel.text = @"点击进行面容ID登录";
        } else {
            self.alertLabel.text = @"点击进行指纹登录";
        }
    }
    return _alertLabel;
}

- (UIButton *)waysButton {
    if (!_waysButton) {
        self.waysButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.waysButton setTitle:@"其他方式登录" forState:UIControlStateNormal];
        [self.waysButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.waysButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.waysButton addTarget:self action:@selector(otherWaysLoginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _waysButton;
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
