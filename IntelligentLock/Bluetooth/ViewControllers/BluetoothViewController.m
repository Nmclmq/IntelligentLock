//
//  BluetoothViewController.m
//  IntelligentLock
//
//  Created by Orient on 2019/4/28.
//  Copyright © 2019 Orient. All rights reserved.
//

#import "BluetoothViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BluetoothKeyViewController.h"
#import "BluetoothLockViewController.h"


static NSString * CellTableIdentifier = @"CellTableIdentifier";
@interface BluetoothViewController ()<UITableViewDelegate,UITableViewDataSource,CBCentralManagerDelegate,CBPeripheralDelegate>
@property (nonatomic, strong)CBCentralManager *centralManager;
@property (nonatomic, strong)CBCentral *selectedPeripheral;
@property (nonatomic, strong)NSMutableArray *peripheralList;


@property(nonatomic, strong)UIView *bluetoothListView;
@property(nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, strong)UIImageView *titleImageView;
@property (nonatomic, strong)UIButton *touchBtn;
@property (nonatomic,strong)UILabel *titleLabel;


@property (nonatomic, strong) UIView * bgView;

@property (nonatomic, strong) NSTimer *timerForPeripheralListFurbish;       // 设备列表刷新计时器
@property (nonatomic, assign) BOOL isStartLoadData;                         // 是否开始加载数据
@property (nonatomic, assign) BOOL isOpenBluebooth;

//控制器
@property(nonatomic, strong)BluetoothKeyViewController * bluetoothKeyVC;
@property(nonatomic, strong)BluetoothLockViewController * bluetoothLockVC;
@end
@implementation BluetoothViewController

- (NSMutableArray *)peripheralList{
    if(!_peripheralList){
        _peripheralList = [[NSMutableArray alloc]init];
        
    }
    return _peripheralList;
}

- (NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [[NSMutableArray alloc]init];
        
    }
    return _dataSource;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]init];
        _tableView.tag = 1000;
        [_tableView setSeparatorColor:[UIColor grayColor]];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setRowHeight:55];
        
        if (@available(iOS  11.0, *)) {
           
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49+34, 0);//导航栏如果使用系统原生半透明的，top设置为64
            _tableView.scrollIndicatorInsets = _tableView.contentInset;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }

        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
     [_tableView reloadData];
    return _tableView;
}

- (UIImageView *)titleImageView{
    if(!_titleImageView){
        _titleImageView = [[UIImageView alloc]init];
       
        [_titleImageView setImage:[UIImage imageNamed:@"Bluetooth-1"]];
        [_titleImageView setAnimationImages:@[
                                              [UIImage imageNamed:@"Bluetooth-1"],
                                              [UIImage imageNamed:@"Bluetooth-2"],
                                              [UIImage imageNamed:@"Bluetooth-3"],
                                              ]];
        [_titleImageView setAnimationDuration:2.0f];
        [_titleImageView setAnimationRepeatCount:0];
        [_titleImageView startAnimating];
    }
    return _titleImageView;
}

- (UIButton *)touchBtn{
    if(!_touchBtn){
        _touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_touchBtn setTitle:@"搜索蓝牙设备" forState:UIControlStateNormal];
        
        [_touchBtn addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
        
        [_touchBtn.layer setCornerRadius:6];
        [_touchBtn setBackgroundColor:COLOR_FOR_MAIN];
        
        
       
       
    }
    return _touchBtn;
}
- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        [_titleLabel setText:@"未开启蓝牙搜索"];
        [_titleLabel setTextColor:COLOR_FOR_MAIN];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _titleLabel;
}


- (BluetoothKeyViewController *)bluetoothKeyVC{
    if(!_bluetoothKeyVC){
        _bluetoothKeyVC = [[BluetoothKeyViewController alloc]init];
    }
    return _bluetoothKeyVC;
}

- (BluetoothLockViewController *)bluetoothLockVC{
    if(!_bluetoothLockVC){
        _bluetoothLockVC = [[BluetoothLockViewController alloc]init];
    }
    return _bluetoothLockVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScreenTopUI];
    [self setScreenBottomUI];
    [self initalize];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)Click{

    UIButton *button = _touchBtn;
    if([self.touchBtn.titleLabel.text isEqualToString:@"搜索蓝牙设备"]){
        [self.touchBtn setTitle:@"关闭蓝牙搜索" forState:UIControlStateNormal];
        [self.titleLabel setText:@"正在动态扫描附近蓝牙设备..."];
        self.isOpenBluebooth = YES;
        self.timerForPeripheralListFurbish = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                                                                                            target:self
                                                                                                                          selector:@selector(peripheralFurbishHandler)
                                                                                                                          userInfo:nil
                                                                                                                           repeats:YES];
        [ShowHUD showLoadingWithMessage:@"正在搜索中..."];
    }else{
        [self.touchBtn setTitle:@"搜索蓝牙设备" forState:UIControlStateNormal];
        [self.titleLabel setText:@"未开启蓝牙搜索"];
                [self.dataSource removeAllObjects];
                [self.tableView reloadData];
                [self.timerForPeripheralListFurbish invalidate];
                self.timerForPeripheralListFurbish = nil;
        
    }
//    if(!self.isOpenBluebooth){
//        self.isOpenBluebooth = YES;
//        [self.touchBtn setTitle:@"搜索蓝牙" forState:UIControlStateNormal];
//        [self.titleLabel setText:@"未开启蓝牙搜索"];
//        [self.dataSource removeAllObjects];
//        [self.tableView reloadData];
//        [self.timerForPeripheralListFurbish invalidate];
//        self.timerForPeripheralListFurbish = nil;
//
//        //        self.timerForPeripheralListFurbish
//    }else{
//
//        self.isOpenBluebooth = NO;
//        [self.touchBtn setTitle:@"停止搜索" forState:UIControlStateNormal];
//        [self.titleLabel setText:@"正在扫描中请稍后..."];
//        self.timerForPeripheralListFurbish = [NSTimer scheduledTimerWithTimeInterval:3.0f
//                                                                              target:self
//                                                                            selector:@selector(peripheralFurbishHandler)
//                                                                            userInfo:nil
//                                                                             repeats:YES];
//    }
    [button customButtonAnimation];
}
- (void)peripheralFurbishHandler{
    if(self.centralManager.state != 5 && self.isOpenBluebooth){
        [ShowHUD hideHUD];
        [ShowHUD showError:@"蓝牙未开启"];
        self.isOpenBluebooth = NO;
        self.isStartLoadData = NO;
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
    }else if(self.centralManager.state == 5){
       self.isStartLoadData = YES;
        self.isOpenBluebooth = YES;
    }
}
- (void)setScreenTopUI{
    NSInteger btnH = 40;
    NSInteger btnW = 200;
    NSInteger btnMarginTop = 40;
    [self.view addSubview:self.titleImageView];
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@(SCREENHEIGHT/10));
        make.left.mas_equalTo(@(SCREENWIDTH/4 *1.5));
        make.height.mas_equalTo(@(SCREENWIDTH/4));
        make.width.mas_equalTo(@(SCREENWIDTH/4));
    }];
    
    [self.view addSubview:self.touchBtn];
    [self.touchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleImageView.mas_bottom).offset(btnMarginTop);
        make.centerX.equalTo(self.titleImageView);
        make.width.mas_equalTo(@(btnW));
        make.height.mas_equalTo(@(btnH));
    }];
}
- (void)setScreenBottomUI{
    NSInteger margin = 10;
    NSInteger labelH = 20;
    NSInteger labelW = 300;
    NSInteger allMargin = 40+10 + SCREENHEIGHT/10;
    NSInteger allHeight = SCREENWIDTH/4 + 40 + 20;
    NSInteger tableViewH = SCREENHEIGHT -allHeight-allMargin-navigationBarAndStatusBarHeight-tabBarHeight;
    [self.view addSubview:self.titleLabel];
   
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.touchBtn.mas_bottom).offset(margin);
        make.left.mas_equalTo(@(margin));
        make.height.mas_equalTo(@(labelH));
        make.width.mas_equalTo(@(labelW));
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(@(0));
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_equalTo(@(tableViewH));
    }];
}

- (void)initalize{
    self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    self.selectedPeripheral = nil;
    self.isStartLoadData = NO;
    self.isOpenBluebooth = YES;
}
#pragma mark tableViewDelegate and tableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource?self.dataSource.count : 0;
//    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section < self.dataSource.count){
        return [[self.dataSource objectAtIndex:section] count];
    }
    return 0;
//    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTableIdentifier];
    }
        NSString * peripheralName = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//    NSString * peripheralName = @"akey0001";
        [cell.textLabel setText:peripheralName];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [cell.textLabel setTextColor:[UIColor colorWithRed:0.33 green:0.73 blue:0.92 alpha:1.00]];
        NSString * detailText = @"未知设备";
        if([peripheralName rangeOfString:@"akey"].location != NSNotFound){
            detailText = @"奥联钥匙";
        }else if([peripheralName rangeOfString:@"FJTT03"].location != NSNotFound || [peripheralName rangeOfString:@"alock"].location != NSNotFound){
            detailText = @"奥联蓝牙板";
        }else if([peripheralName rangeOfString:@"FJTT09"].location != NSNotFound){
            detailText = @"邦讯蓝牙版";
        }
        [cell.detailTextLabel setText:detailText];
        [cell.detailTextLabel setTextColor:[UIColor colorWithRed:0.95 green:0.31 blue:0.27 alpha:1.00]];
        [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString * cellText = cell.textLabel.text;
    if([cellText rangeOfString:@"akey"].location != NSNotFound){
        [self.navigationController pushViewController:self.bluetoothKeyVC animated:YES];
        
        self.tabBarController.tabBar.hidden=YES;
    }else if([cellText rangeOfString:@"alock"].location != NSNotFound || [cellText rangeOfString:@"FJTT03"].location != NSNotFound || [cellText rangeOfString:@"FJTT09"].location != NSNotFound){
        
        [self.navigationController pushViewController:self.bluetoothLockVC animated:YES];
        self.tabBarController.tabBar.hidden=YES;
        
    }else{
        [ShowHUD showError:@"未知蓝牙"];
    }
}
#pragma mark CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (self.centralManager.state) {
        case CBManagerStatePoweredOn:
        {
            [self.centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
        }
            break;
        case CBManagerStatePoweredOff:
        {
            NSLog(@"设备蓝牙未打开");
        }
            
        default:
            break;
    }
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    if (self.isStartLoadData) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObject:[[self.peripheralList copy] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSComparisonResult result = [obj2 compare:obj1];
            return result;
        }]];
        self.isStartLoadData = NO;
        [self.peripheralList removeAllObjects];
        [self.tableView reloadData];
         [ShowHUD hideHUD];
    } else {
        if (peripheral.name && [self.peripheralList containsObject:peripheral.name] == NO) {
            [self.peripheralList addObject:peripheral.name];
            
        }
    }
}
@end
