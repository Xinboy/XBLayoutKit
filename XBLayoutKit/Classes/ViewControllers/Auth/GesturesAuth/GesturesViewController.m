//
//  GesturesViewController.m
//  pydx
//
//  Created by Xinbo Hong on 2020/2/18.
//  Copyright © 2020年 Xinbo Hong. All rights reserved.
//

#import "GesturesViewController.h"
#import "GesturesView.h"
#import <Masonry.h>


@interface GesturesViewController ()<GesturesViewDelegate>

@property (nonatomic, strong) GesturesView *gesView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *alertLabel;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIButton *jumpButton;

@property (nonatomic, strong) UIColor *norColor;

@end

@implementation GesturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:249 / 255.0 alpha:1.0];
    self.norColor = [UIColor colorWithWhite:168 / 255.0 alpha:1.0];
    
    [self.view addSubview:self.gesView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.alertLabel];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.jumpButton];
    
    [self initUI];
}

- (void)initUI {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.gesView.mas_top).offset(-100);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
        make.centerX.equalTo(self.view);
    }];
    
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.gesView.mas_top).offset(-40);
        make.height.mas_equalTo(20);
    }];
    
    [self.gesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(250);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gesView.mas_bottom).offset(70);
        make.centerX.equalTo(self.gesView.mas_left);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(44);
    }];
    
    [self.jumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backButton);
        make.centerX.equalTo(self.gesView.mas_right);
        make.width.equalTo(self.backButton);
        make.height.equalTo(self.backButton);
    }];
}

#pragma mark - **************** Event response methods
- (BOOL)hasGesturesLogin {
    return [GesturesView hasGesturesLogin];
}

- (void)isSettingGesture:(BOOL)isSetting {
    if (isSetting) {
        self.titleLabel.text = @"请设置手势密码";
    } else {
        self.titleLabel.text = @"请输入手势密码";
    }
    self.gesView.settingGesture = isSetting;
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)jump {
    //直接走登陆成功的界面
}

#pragma mark - --- GesturesViewDelegate ---
- (void)gesturesView:(GesturesView *)gesturesView error:(NSString *)errorName {
    self.alertLabel.text = errorName;
}

- (void)gesturesView:(GesturesView *)gesturesView status:(NSString *)status {
    if ([status isEqualToString:@"1"]) {
        self.titleLabel.text = @"请再次设置手势密码";
    }
    if ([status isEqualToString:@"0"]) {
        self.alertLabel.text = @"";
    }
    
}

- (void)gesturesView:(GesturesView *)gesturesView settingStatus:(BOOL)isSuccess {
    if (isSuccess) {
        //设置成功，跳转
    
    }
    
}

- (void)gesturesView:(GesturesView *)gesturesView unlockStatus:(BOOL)isSuccess {
    if (isSuccess) {
        //解锁成功
        
    }
}


#pragma mark - **************** Getter and setter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)alertLabel {
    if (!_alertLabel) {
        self.alertLabel = [[UILabel alloc] init];
        self.alertLabel.textAlignment = NSTextAlignmentCenter;
        self.alertLabel.textColor = [UIColor redColor];
        self.alertLabel.font = [UIFont systemFontOfSize:15];
        
    }
    return _alertLabel;
}


- (GesturesView *)gesView {
    if (!_gesView) {
        self.gesView = [[GesturesView alloc] initWithFrame:CGRectMake(50, 200, 250, 250) selectedColor:[UIColor colorWithWhite:168 / 255.0 alpha:1.0]];
        self.gesView.delegate = self;
    }
    return _gesView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        self.backButton = [[UIButton alloc] init];
        [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
        [self.backButton setTitleColor:self.norColor forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backButton;
}

- (UIButton *)jumpButton {
    if (!_jumpButton) {
        self.jumpButton = [[UIButton alloc] init];
        [self.jumpButton setTitle:@"跳过" forState:UIControlStateNormal];
        [self.jumpButton setTitleColor:[UIColor colorWithRed:62 / 255.0 green:162 / 255.0 blue:243 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.jumpButton addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _jumpButton;
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
