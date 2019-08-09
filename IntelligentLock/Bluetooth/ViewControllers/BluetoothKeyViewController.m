//
//  BluetoothKeyViewController.m
//  IntelligentLock
//
//  Created by Orient on 2019/4/30.
//  Copyright © 2019 Orient. All rights reserved.
//

#import "BluetoothKeyViewController.h"
#import "KeyBaseInfoView.h"
@interface BluetoothKeyViewController ()
@property (nonatomic, strong)UIImageView * titleImageView;
@property (nonatomic, strong)UIButton *bindBtn;
@property (nonatomic, strong)UIButton *disconnectBtn;
@property (nonatomic, strong)UIView *initializationView;
@property (nonatomic, strong)UIView * useView;

@property (nonatomic, assign)BOOL isBind;
@end

@implementation BluetoothKeyViewController

- (UIImageView *)titleImageView{
    if(!_titleImageView){
        _titleImageView = [[UIImageView alloc]init];
        [_titleImageView setImage:[UIImage imageNamed:@"MyKeyIcon"]];
    }
    return _titleImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isBind = YES;
    [self settingUpTheUIInterface];
}

-(void)settingUpTheUIInterface{
    [self.view setBackgroundColor:COLOR_FOR_MAIN_BACKGROUND];
    
    [self.view addSubview:self.titleImageView];
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@(SCREENHEIGHT/10));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(@(SCREENWIDTH/4));
        make.height.mas_equalTo(@(SCREENWIDTH/4));
        
    }];
    KeyBaseInfoView * contentView = [[KeyBaseInfoView alloc]init];
    UIView * view = [contentView createTheBasicInterface];
    [self.view addSubview:view];
    UIView * cacheView = [[UIView alloc]init];
    [cacheView setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.93 alpha:1.00]];
    [cacheView.layer setCornerRadius:6];
    NSArray * btnNameArr = nil;
//    UIView * view=nil;
    [self.view addSubview:cacheView];
    [cacheView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_bottom).offset(-10);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(SCREENWIDTH-40);
        make.height.mas_equalTo(70);
        
    }];
    if(self.isBind){
        self.initializationView = cacheView;
        btnNameArr = @[@"断开连接",@"初始化钥匙",];
        
    }else{
        self.useView = cacheView;
        btnNameArr = @[@"断开连接",@"使用授权",@"其它操作",];
    }
    for (NSInteger i=0; i<btnNameArr.count; i++){
        UIButton * mediumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mediumBtn setBackgroundColor:[UIColor colorWithRed:0.19 green:0.76 blue:0.84 alpha:1.00]];
        [mediumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [mediumBtn.layer setCornerRadius:6];
        [mediumBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [mediumBtn setTitle:btnNameArr[i] forState:UIControlStateNormal];
        [mediumBtn addTarget:self action:@selector(bindBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if(self.isBind){
            [mediumBtn setTag:1005+i];
           
        }else{
            [mediumBtn setTag:1007+i];
            [self.useView addSubview:mediumBtn];
        }
        switch (mediumBtn.tag) {
            case 1005:
            {
                self.disconnectBtn = mediumBtn;
                 [self.initializationView addSubview:self.disconnectBtn];
            }
                break;
            case 1006:
            {
                self.bindBtn = mediumBtn;
                [self.initializationView addSubview:self.bindBtn];
                
                
            }
                break;
            case 1007:
            {
                self.bindBtn = mediumBtn;
                 [self.useView addSubview:self.bindBtn];
            }
                break;
            case 1008:
            {
                self.bindBtn = mediumBtn;
                [self.useView addSubview:self.bindBtn];
            }
                break;
            case 1009:
            {
                self.bindBtn = mediumBtn;
                [self.useView addSubview:self.bindBtn];
            }
                break;
            default:
                NSLog(@"超出范围");
                
                break;
        }
        [mediumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cacheView.mas_centerY);
            make.left.mas_equalTo(cacheView.mas_left).offset(((SCREENWIDTH-40-20 * (btnNameArr.count+1))/btnNameArr.count +20) * i +20);
            //make.centerX.mas_equalTo(self.operationView.mas_centerX);
            make.width.mas_equalTo((SCREENWIDTH-40 -20 * (btnNameArr.count+1))/btnNameArr.count );
            make.height.mas_equalTo(40);
        }];
    }
   [self.view bringSubviewToFront:view];
}


- (void)bindBtnClick:(UIButton *)sender{
    switch (sender.tag) {
        case 1005:
        case 1007:
            NSLog(@"断开连接");
            break;
        case 1006:
            NSLog(@"绑定钥匙");
            break;
        case 1008:
            NSLog(@"下发授权");
            break;
        case 1009:
            NSLog(@"其它操作");
            break;
        default:
            NSLog(@"未知");
            break;
    }
    [sender customButtonAnimation];
}

@end
