//
//  KeyBaseInfoView.m
//  IntelligentLock
//
//  Created by Orient on 2019/4/30.
//  Copyright © 2019 Orient. All rights reserved.
//

#import "KeyBaseInfoView.h"
#import "DetailInfoView.h"
@interface KeyBaseInfoView ()
@property (nonatomic, strong)DetailInfoView * backgroundView;
@property (nonatomic, strong)UIView * keyStateView;//信号电量所在view
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UIView * bluetoothSignalView;//蓝牙信息号view
@property (nonatomic, strong)UIView * bluetoothSignalBackgroundView;
@property (nonatomic, strong)UIView * bluetoothPowerView;//电量view
@property (nonatomic, strong)UIImageView * bluetoothPowerBackgroundView;//
@property (nonatomic, strong)UIView * bindView; //绑定view
@property (nonatomic, strong)UIView * useView;//使用按钮view

@property (nonatomic, strong)UILabel * imeiLabel;
@property (nonatomic, strong)UILabel * macLable;
@property (nonatomic, strong)UILabel * versionLabel;
@property (nonatomic, strong)UILabel * connectCoreLockLabel;
@property (nonatomic, strong)UILabel * keyEnableLabel;


@property (nonatomic, strong)UIButton *bindBtn;

@property (nonatomic, strong)UIView * separatorView;   //间隔线

@property (nonatomic, strong)UIView * contentInfoView; //信息展示view
@property (nonatomic, strong) UILabel *labelForRSSI;                                  // 蓝牙信号指标
@property (nonatomic, strong) UIView *viewForDumpEnergyIcon;                          // 剩余电量图标
@property (nonatomic, strong) UILabel *labelForDumpEnergy;                            // 剩余电量大小
@property (nonatomic, strong) UIView *viewForSignalIcon;                              // 蓝牙信息图标

@property (nonatomic, assign) NSInteger viewWidth;
@property (nonatomic, assign) NSInteger viewHeight;
@property (nonatomic, assign) NSInteger margin;

@property (nonatomic, assign) BOOL isBind;
@end

@implementation KeyBaseInfoView

- (UIView *)createTheBasicInterface{
    self.isBind = NO;
    self.margin = 10;
    NSInteger marginY = SCREENHEIGHT/10 + SCREENWIDTH/4 + 40;
    self.viewWidth = SCREENWIDTH-4*self.margin;
    self.viewHeight = SCREENHEIGHT * 2/5;
    CGRect detailInfoViewRect = CGRectZero;
    detailInfoViewRect.size.width = self.viewWidth;
    detailInfoViewRect.size.height = self.viewHeight;
    detailInfoViewRect.origin.x = (CGRectGetWidth([UIScreen mainScreen].bounds) - detailInfoViewRect.size.width) / 2.0;
    detailInfoViewRect.origin.y = marginY;
    
    
    self.backgroundView = [[DetailInfoView alloc]initWithFrame:detailInfoViewRect];
    [self.backgroundView addSubview:self.titleLabel];
    [self settingTheTitleInterfaceLayer];
    
    self.separatorView = [self createSeparatorView];
    [self.backgroundView addSubview:self.separatorView];
    [self settingTheSeparatorView:self.titleLabel width:self.viewWidth height:1];
    
    [self.backgroundView addSubview:self.keyStateView];
    [self settingTheKeyStateViewInterfaceLayer];

     self.separatorView = [self createSeparatorView];
    [self.backgroundView addSubview:self.separatorView];
    [self settingTheSeparatorView:self.keyStateView width:self.viewWidth height:1];
    [self.backgroundView addSubview:self.bluetoothSignalView];
    [self settingTheBluetoothSignalViewInterfaceLayer];
    
    self.separatorView = [self createSeparatorView];
    [self.keyStateView addSubview:self.separatorView];
    [self settingTheSeparatorView:self.self.titleLabel width:1 height:self.viewHeight * 2/7];
    
    [self.backgroundView addSubview:self.bluetoothPowerView];
    [self settingTheBluetoothPowerViewInterfaceLayer];
    
    [self.backgroundView addSubview:self.contentInfoView];
    [self settingTheContentInfoViewInterfaceLayer];
    
    [self.bluetoothSignalView addSubview:self.bluetoothSignalBackgroundView];
    [self settingTheBluetoothSignalBackgroundViewInterfaceLayer];
    [self.bluetoothPowerView addSubview:self.bluetoothPowerBackgroundView];
    [self settingSignalView];
    [self settingPowerView];
    return self.backgroundView;
}
- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [_titleLabel setText:@"钥匙基本信息"];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
    }
    return _titleLabel;
}
- (UIView *)keyStateView{
    if(!_keyStateView){
        _keyStateView = [[UIView alloc]init];
        [_keyStateView setBackgroundColor:[UIColor clearColor]];
    }
    return _keyStateView;
}
- (UIView *)bluetoothSignalView{
    if(!_bluetoothSignalView){
        _bluetoothSignalView = [[UIView alloc]init];
        [_bluetoothSignalView setBackgroundColor:[UIColor clearColor]];
    }
    return _bluetoothSignalView;
}
- (UIView *)bluetoothPowerView{
    if(!_bluetoothPowerView){
        _bluetoothPowerView = [[UIView alloc]init];
        [_bluetoothPowerView setBackgroundColor:[UIColor clearColor]];
    }
    return _bluetoothPowerView;
}
- (UIView *)contentInfoView{
    if(!_contentInfoView){
        _contentInfoView = [[UIView alloc]init];
        [_contentInfoView setBackgroundColor:[UIColor clearColor]];
    }
    return _contentInfoView;
}
//- (UIView *)bindView{
//    if(!_bindView){
//        _bindView = [[UIView alloc]init];
//        [_bindView setBackgroundColor:[UIColor clearColor]];
//        [_bindView setUserInteractionEnabled:YES];
//        
//    }
//    return _bindView;
//}
//
//- (UIView *)useView{
//    if(!_useView){
//        _useView = [[UIView alloc]init];
//        [_useView setBackgroundColor:[UIColor clearColor]];
//    }
//    return _useView;
//}

- (UIView *)createSeparatorView{
  
        UIView * separatorView = [[UIView alloc]init];
        [separatorView setBackgroundColor:[UIColor grayColor]];
    return separatorView;
}

- (UIView *)bluetoothSignalBackgroundView{
    if(!_bluetoothSignalBackgroundView){
        _bluetoothSignalBackgroundView = [[UIView alloc]init];

    }
    return _bluetoothSignalBackgroundView;
}
- (UIView *)bluetoothPowerBackgroundView{
    if(!_bluetoothPowerBackgroundView){
        _bluetoothPowerBackgroundView = [[UIImageView alloc]init];
        [_bluetoothPowerBackgroundView setImage:[UIImage imageNamed:@"BatteryIcon001"]];
    }
    return _bluetoothPowerBackgroundView;
}
- (UILabel *)labelForRSSI{
    if(!_labelForRSSI){
        _labelForRSSI = [[UILabel alloc]init];
        [_labelForRSSI setText:@"00dB"];
        [_labelForRSSI setTextColor:[UIColor colorWithRed:0.00 green:0.68 blue:0.94 alpha:1.00]];
        [_labelForRSSI setTextAlignment:NSTextAlignmentCenter];
        [_labelForRSSI setFont:[UIFont systemFontOfSize:12.0f]];
    }
    return _labelForRSSI;
}

- (UILabel *)labelForDumpEnergy{
    if(!_labelForDumpEnergy){
        _labelForDumpEnergy = [[UILabel alloc]init];
        [_labelForDumpEnergy setTextAlignment:NSTextAlignmentCenter];
        [_labelForDumpEnergy setText:@"0%"];
        [_labelForDumpEnergy setFont:[UIFont systemFontOfSize:12.0f]];
        [_labelForDumpEnergy setTextColor:[UIColor colorWithRed:0.30 green:0.86 blue:0.39 alpha:1.00]];
    }
    return _labelForDumpEnergy;
}



- (void)settingSignalView{
    NSInteger signalView = self.viewHeight * 2/7 *1/3 * 3/5;
    for (NSInteger i=0; i<4; i++) {
        UIView * view = [[UIView alloc]init];
        [view setBackgroundColor:[UIColor lightGrayColor]];
        [self.bluetoothSignalBackgroundView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.bluetoothSignalBackgroundView.mas_bottom).offset(0);
            make.left.mas_equalTo( i*(signalView* 1/4+1 ));
            make.width.mas_equalTo(signalView * 1/4);
            make.height.mas_equalTo(signalView * (i+1)/4 );
        }];
    }
    
    [self.bluetoothSignalView addSubview:self.labelForRSSI];
    [self.labelForRSSI mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bluetoothSignalView.mas_centerX);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.bluetoothSignalBackgroundView.mas_bottom).offset(0);
        make.width.mas_equalTo(self.viewWidth/2);
        make.height.mas_equalTo(self.viewHeight * 2/7 *1/3-5);
    }];
    
    UILabel * nameLabel = [[UILabel alloc]init];
    [nameLabel setText:@"蓝牙信号强度"];
    [nameLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [nameLabel setTextColor:[UIColor grayColor]];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.bluetoothSignalView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labelForRSSI.mas_bottom).offset(0);
        make.width.mas_equalTo(self.viewWidth/2);
        make.height.mas_equalTo(self.viewHeight * 2/7 * 1/3 - 10);
    }];
    
}

- (void)settingPowerView{
    [self.bluetoothPowerBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bluetoothPowerView.mas_top).offset(10+self.viewHeight * 2/7 *1/3*2/7);
        make.centerX.mas_equalTo(self.bluetoothPowerView.mas_centerX);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(self.viewHeight * 2/7 *1/3);
        
    }];
    
    [self.bluetoothPowerView addSubview:self.labelForDumpEnergy];
    [self.labelForDumpEnergy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bluetoothPowerView.mas_centerX);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.self.labelForRSSI.mas_top);
        make.width.mas_equalTo(self.viewWidth/2);
        make.height.mas_equalTo(self.viewHeight * 2/7 *1/3-5);
    }];
    UILabel * nameLabel = [[UILabel alloc]init];
    [nameLabel setText:@"钥匙剩余电量"];
    [nameLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [nameLabel setTextColor:[UIColor grayColor]];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.bluetoothPowerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labelForRSSI.mas_bottom).offset(0);
        make.width.mas_equalTo(self.viewWidth/2);
        make.height.mas_equalTo(self.viewHeight * 2/7 * 1/3 - 10);
    }];
    
}


- (void)settingTheSeparatorView:(UIView *)obj width:(NSInteger)width height:(NSInteger)height{
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(obj.mas_centerX);
        make.top.mas_equalTo(obj.mas_bottom).offset(0);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
        
    }];
}


-(void )settingTheTitleInterfaceLayer{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.margin);
        make.width.mas_equalTo(@(self.viewWidth));
        make.height.mas_equalTo(@(self.viewHeight / 7));
    }];
}
-(void)settingTheKeyStateViewInterfaceLayer{
    [self.keyStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(1);
        make.width.mas_equalTo(self.viewWidth);
        make.height.mas_equalTo(self.viewHeight * 2/7);
    }];
}
-(void)settingTheBluetoothSignalViewInterfaceLayer{
    
    [self.bluetoothSignalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.keyStateView.mas_top).offset(0);
        make.left.mas_offset(0);
        make.width.mas_equalTo(self.viewWidth/2);
        make.height.mas_equalTo(self.viewHeight * 2/7);
    }];
}
-(void)settingTheBluetoothPowerViewInterfaceLayer{
    [self.bluetoothPowerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.keyStateView.mas_top).offset(0);
        make.left.mas_offset(self.viewWidth/2);
        make.width.mas_equalTo(self.viewWidth/2 +1);
        make.height.mas_equalTo(self.viewHeight * 2/7);
    }];
}
-(void)settingTheContentInfoViewInterfaceLayer{
    NSInteger  contentInfoViewH = self.viewHeight * 4/7;
    [self.contentInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.keyStateView.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.viewWidth);
        make.height.mas_equalTo(contentInfoViewH);
    }];
    
    NSArray * arr = @[@"设备IMEI:",@"MAC地址:",@"版本号:",@"锁芯状态:",@"绑定状态:",];

    for (NSInteger i=0;i<arr.count;i++) {
        UILabel * nameLabel = [[UILabel alloc]init];
        [nameLabel setTextColor:[UIColor blackColor]];
        [nameLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [nameLabel setTextAlignment:NSTextAlignmentRight];
        [nameLabel setText:arr[i]];
        [self.contentInfoView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10 + (contentInfoViewH-10)/5 * i);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(self.viewWidth/4);
            make.height.mas_equalTo((contentInfoViewH-10)/5);
        }];
        
        UILabel * infoLable =  [[UILabel alloc]init];
        [infoLable setText:@"— —"];
        [infoLable setTextColor:[UIColor grayColor]];
        [infoLable setFont:[UIFont systemFontOfSize:13.0f]];
        [infoLable setTextAlignment:NSTextAlignmentLeft];
        switch (i) {
            case 0:
            {
                self.imeiLabel = infoLable;
                [self.contentInfoView addSubview:self.imeiLabel];
            }
                break;
            case 1:
            {
                self.macLable = infoLable;
                [self.contentInfoView addSubview:self.macLable];
                
            }
                break;
            case 2:
            {
                self.versionLabel = infoLable;
                [self.contentInfoView addSubview:self.versionLabel];
            }
                break;
            case 3:
            {
                self.connectCoreLockLabel = infoLable;
                [self.contentInfoView addSubview:self.connectCoreLockLabel];
            }
                break;
            case 4:
            {
                self.keyEnableLabel = infoLable;
                [self.contentInfoView addSubview:self.keyEnableLabel];
            }
                break;
                
            default:
                break;
        }
        
        
        [infoLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10 + (contentInfoViewH-10)/5 * i);
            make.left.mas_equalTo(self.viewWidth * 1/4+10);
            make.width.mas_equalTo(self.viewWidth * 3/4);;
            make.height.mas_equalTo((contentInfoViewH-10)/5);
        }];
    }
    
}


- (void)settingTheBluetoothSignalBackgroundViewInterfaceLayer{
    [self.bluetoothSignalBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bluetoothSignalView.mas_top).offset(10);
        make.centerX.mas_equalTo(self.bluetoothSignalView.mas_centerX);
        make.width.mas_equalTo(self.viewHeight * 2/7 *1/3* 3/5);
        make.height.mas_equalTo(self.viewHeight * 2/7 *1/3);
        
    }];
    
  
}




@end
