//
//  LoginViewController.m
//  IntelligentLock
//
//  Created by Orient on 2019/5/16.
//  Copyright © 2019 Orient. All rights reserved.


#import "LoginViewController.h"
#import "UserModel.h"
#import "ServerIPSETView.h"

#define COLOR_FOR_PLACEHOLDER      [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00]
#define COLOR_FOR_TEXT_FIELD       [UIColor colorWithRed:105/255.00 green:114/255.00 blue:118/255.00 alpha:1.00]
@interface LoginViewController ()<UITextFieldDelegate>
{
    BOOL keyboardVisible;
    UIView *activeView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *backgoundScrollView;

@property (nonatomic, strong)UserModel * userModel;
@property (nonatomic, strong)UITextField * userName;
@property (nonatomic, strong)UITextField * password;
@property (nonatomic, strong)UIImageView * iconImageView;
@property (nonatomic, strong)UIButton *loginBtn;
@property (nonatomic, strong)UIButton *passagewayBtn;
@property (nonatomic, strong)ServerIPSETView * setIPVIew;

@property (nonatomic, strong)UIView * backgoundView;

@property (nonatomic, strong)UIView *textFieldBackground;


@end

@implementation LoginViewController


- (UIImageView *)iconImageView{
    if(!_iconImageView){
        _iconImageView = [[UIImageView alloc]init];
        [_iconImageView setImage:[UIImage imageNamed:@"AppIcon"]];
        [_iconImageView.layer setCornerRadius:50];
        [_iconImageView setClipsToBounds:YES];
    }
    return _iconImageView;
}

- (UITextField *)userName{
    if(!_userName){
        _userName = [[UITextField alloc]init];
        [_userName setTextColor:[UIColor whiteColor]];
        [_userName setDelegate:self];
        [_userName setBackgroundColor:COLOR_FOR_TEXT_FIELD];
        [_userName.layer setCornerRadius:6];
//        [_userName setBackgroundColor:[UIColor grayColor]];
        
        [_userName setLeftView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LoginUsernameIcon"]]];
        [_userName setLeftViewMode:UITextFieldViewModeAlways];
        [_userName setPlaceholder:@"请输入账号"];
        [_userName setValue:COLOR_FOR_PLACEHOLDER forKeyPath:@"placeholderLabel.textColor"];
        [_userName setFont:[UIFont systemFontOfSize:16.0f]];
        [_userName setKeyboardType:UIKeyboardTypeNumberPad];
        //私有方法设置
    }
    return _userName;
}

- (UITextField *)password{
    if(!_password){
        _password = [[UITextField alloc]init];
        [_password setTextColor:[UIColor whiteColor]];
        
        [_password setDelegate:self];
        [_password setBackgroundColor:[UIColor clearColor]];
        [_password.layer setCornerRadius:6];
//        [_password setBackgroundColor:[UIColor grayColor]];
        [_password setLeftView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LoginPasswordIcon"]]];
        [_password setLeftViewMode:UITextFieldViewModeAlways];
        [_password setPlaceholder:@"请输入密码"];
        [_password setValue:COLOR_FOR_PLACEHOLDER forKeyPath:@"placeholderLabel.textColor"];
        [_password setFont:[UIFont systemFontOfSize:16.0f]];
//        [_password setKeyboardType:UIKeyboardTypeDefault];
    }
    return _password;
}

- (UIButton *)loginBtn{
    if(!_loginBtn){
        _loginBtn = [[UIButton alloc]init];
        [_loginBtn setTag:1100];
        [_loginBtn.layer setCornerRadius:6];
        [_loginBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [_loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:COLOR_FOR_MAIN];
        [_loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}
- (UIButton *)passagewayBtn{
    if(!_passagewayBtn){
        _passagewayBtn = [[UIButton alloc]init];
        [_passagewayBtn setTag:1101];
        [_passagewayBtn.layer setCornerRadius:6];
        [_passagewayBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [_passagewayBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [_passagewayBtn setTitle:@"通 道 配 置" forState:UIControlStateNormal];
        [_passagewayBtn setBackgroundColor:COLOR_FOR_MAIN];
        [_passagewayBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passagewayBtn;
}

- (UIView *)backgoundView{
    if(!_backgoundView){
        _backgoundView = [[UIView alloc]init];
        [_backgoundView setBackgroundColor:[UIColor clearColor]];
    }
    return _backgoundView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingUpUserLoginInterface];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification
                                               object:nil];
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.backgoundScrollView addGestureRecognizer:tapGestureRecognizer];
}


- (void)settingUpUserLoginInterface{
    
    NSInteger backgoundViewH = SCREENHEIGHT * 4/5;
    NSInteger Height = 50;
     UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [self.backgoundView addGestureRecognizer:tapGestureRecognizer];
    [self.backgoundScrollView addSubview:self.backgoundView];
    [self.backgoundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.backgoundScrollView.mas_centerX);
        make.centerY.mas_equalTo(self.backgoundScrollView.mas_centerY);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(backgoundViewH);
    }];
    [self.backgoundView addSubview:self.iconImageView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backgoundViewH/10);
        make.centerX.mas_equalTo(self.backgoundView.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    for (NSInteger i=0; i<2; i++) {
        self.textFieldBackground = [[UIView alloc]init];
        [self.textFieldBackground setBackgroundColor:COLOR_FOR_TEXT_FIELD];
        [self.textFieldBackground.layer setCornerRadius:6];
        [self.backgoundView addSubview:self.textFieldBackground];
        
        [self.textFieldBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImageView.mas_bottom).mas_offset((i+1)*50 + i*10);
            make.centerX.mas_equalTo(self.backgoundView.mas_centerX);
            make.width.mas_equalTo(SCREENWIDTH-20);
            make.height.mas_equalTo(Height);
        }];
        switch (i) {
            case 0:
            {
                [self.textFieldBackground addSubview:self.userName];
                [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(self.textFieldBackground.mas_centerY);
                    make.centerX.mas_equalTo(self.textFieldBackground.mas_centerX);
                    make.width.mas_equalTo(SCREENWIDTH-40);
                    make.height.mas_equalTo(Height);
                }];
            }
                break;
            case 1:
            {
                [self.textFieldBackground addSubview:self.password];
                
                [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(self.textFieldBackground.mas_centerY);
                    make.centerX.mas_equalTo(self.textFieldBackground.mas_centerX);
                    make.width.mas_equalTo(SCREENWIDTH-40);
                    make.height.mas_equalTo(Height);
                }];
            }
                break;
            default:
                break;
        }
    }
    [self.backgoundView addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.self.password.mas_bottom).offset(Height);
        make.centerX.mas_equalTo(self.backgoundView.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH-20);
        make.height.mas_equalTo(Height);
    }];
    [self.backgoundView addSubview:self.passagewayBtn];
    [self.passagewayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.backgoundView.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH-20);
        make.height.mas_equalTo(Height);
    }];
}
#pragma make click
- (void)loginClick:(UIButton *)btn{
    NSLog(@"点击事件%ld",(long)btn.tag);
}
- (void)keyboardDidShow:(NSNotification *)notification{
    // 获取键盘尺寸
    NSDictionary *info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    // 获取要显示区域的y轴长度
    CGFloat showPartY = self.backgoundView.frame.origin.y + self.loginBtn.frame.origin.y + self.loginBtn.frame.size.height + 28;
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height -= keyboardSize.height;
    if (!CGRectContainsRect(viewFrame, activeView.frame)) {  // 判断要显示的区域是否被遮住
        CGPoint scrollPoint = CGPointMake(0.0, showPartY - viewFrame.size.height); // 要滚动到的位置
        [self.backgoundScrollView setContentOffset:scrollPoint animated:YES];
    }
}
- (void)keyboardDidHide:(NSNotification *)notif
{
    [self.backgoundScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

- (void)tapScreen:(UITapGestureRecognizer *) recognizer
{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    
}
# pragma mark - UITextField 代理方法

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeView = self.backgoundView;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeView = nil;
}

@end

