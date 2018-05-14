//
//  SystemJumpViewController.m
//  CompentTest
//
//  Created by qrh on 2018/3/8.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "SystemJumpViewController.h"

#define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)

@interface SystemJumpViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *dataDic;
@end

@implementation SystemJumpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 无线局域网    App-Prefs:root=WIFI
 蓝牙    App-Prefs:root=Bluetooth
 蜂窝移动网络    App-Prefs:root=MOBILE_DATA_SETTINGS_ID
 个人热点    App-Prefs:root=INTERNET_TETHERING
 运营商    App-Prefs:root=Carrier
 通知    App-Prefs:root=NOTIFICATIONS_ID
 通用    App-Prefs:root=General
 通用-关于本机    App-Prefs:root=General&path=About
 通用-键盘    App-Prefs:root=General&path=Keyboard
 通用-辅助功能    App-Prefs:root=General&path=ACCESSIBILITY
 通用-语言与地区    App-Prefs:root=General&path=INTERNATIONAL
 通用-还原    App-Prefs:root=Reset
 墙纸    App-Prefs:root=Wallpaper
 Siri    App-Prefs:root=SIRI
 隐私    App-Prefs:root=Privacy
 Safari    App-Prefs:root=SAFARI
 音乐    App-Prefs:root=MUSIC
 音乐-均衡器    App-Prefs:root=MUSIC&path=com.apple.Music:EQ
 照片与相机    App-Prefs:root=Photos
 FaceTime    App-Prefs:root=FACETIME
 */

-(NSDictionary *)dataDic{
    return @{@"无线局域网":@"App-Prefs:root=WIFI",
             @"蓝牙" :    @"App-Prefs:root=Bluetooth",
             @"蜂窝移动网络":@"App-Prefs:root=MOBILE_DATA_SETTINGS_ID",
             @"个人热点":   @"App-Prefs:root=INTERNET_TETHERING",
             @"运营商"  :@"App-Prefs:root=Carrier",
             @"通知":   @"App-Prefs:root=NOTIFICATIONS_ID",
             @"通用":   @"App-Prefs:root=General",
             @"通用-关于本机":    @"App-Prefs:root=General&path=About",
             @"通用-键盘":   @"App-Prefs:root=General&path=Keyboard",
             @"通用-辅助功能" :   @"App-Prefs:root=General&path=ACCESSIBILITY",
             @"通用-语言与地区":   @"App-Prefs:root=General&path=INTERNATIONAL",
             @"通用-还原"  :  @"App-Prefs:root=Reset",
             @"墙纸":    @"App-Prefs:root=Wallpaper",
             @"Siri" :  @"App-Prefs:root=SIRI",
             @"隐私"  :  @"App-Prefs:root=Privacy",
             @"Safari"  :  @"App-Prefs:root=SAFARI",
             @"音乐"  :  @"App-Prefs:root=MUSIC",
             @"音乐-均衡器"  :  @"App-Prefs:root=MUSIC&path=com.apple.Music:EQ",
             @"照片与相机"   : @"App-Prefs:root=Photos",
             @"FaceTime"  :  @"App-Prefs:root=FACETIME"};
}

-(NSString *)getSystemSchemeWithName:(NSString *)name{
    return self.dataDic[name];
}

-(void)jumpSystemWithurlString:(NSString *)urlString{
    NSLog(@"%@",urlString);
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//        if(iOS10){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
//        }else{
#else
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
#endif
//        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataDic.allKeys.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *defaultCellId = @"defaultCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    cell.textLabel.text = self.dataDic.allKeys[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self jumpSystemWithurlString:[self getSystemSchemeWithName:self.dataDic.allKeys[indexPath.row]]];
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}

@end
