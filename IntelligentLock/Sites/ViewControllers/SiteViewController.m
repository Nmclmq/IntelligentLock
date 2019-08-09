//
//  SiteViewController.m
//  IntelligentLock
//
//  Created by Orient on 2019/4/28.
//  Copyright © 2019 Orient. All rights reserved.
//

#import "SiteViewController.h"
#import "ALSiteListAPI.h"
@interface SiteViewController ()

@end

@implementation SiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    ALRequestMethod * method = [[ALRequestMethod alloc]init];
    method.requestType = ALGET;
    method.tryMethod = ALTryRetry;
    method.apiName = @"Site Data";
    method.url = @"http://t.weather.sojson.com/api/weather/city/101030100";
    
    
//    [ALSiteListAPI searchStore:@"" nearCoordinate:@"" withStartIndex:1 success:^BOOL(NSDictionary * _Nonnull data) {
//        return YES;
//    } failure:^BOOL(NSError * _Nonnull err) {
//        return NO;
//    }];
    
    [ALSiteListAPI getDisCountsWithStartIndex:0 success:^BOOL(id  _Nonnull data) {
        return NO;
    } failure:^BOOL(NSError * _Nonnull err) {
        return YES;
    }];
//    [ALSiteListAPI getDisCountsWithStartIndex:0 success:^BOOL(id  _Nullable __autoreleasing *data) {
//        return YES;
//    } failure:^BOOL(NSError * _Nonnull err) {
//        return NO;
//    }];
//    [ALSiteListAPI getDisCountsWithStartIndex:1 success:^BOOL(id  *data) {
//        
//    } failure:^BOOL(NSError *  err) {
//        
//    }];
    
//    [ALSiteListAPI getDisCountsWithStartIndex:1 success:^BOOL(id  _Nonnull *data) {
//        NSLog(@"测试完毕%@",data);
//    } failure:^BOOL(NSError * _Nonnull err) {
//        NSLog(@"测试失败%@",err);
//    }];
//    [ALSiteListAPI getDisCountsWithStartIndex:0 success:^BOOL(id  *data) {
//        
//        NSLog(@"测试完毕%@",data);
//    } failure:^BOOL(NSError *  err) {
//        NSLog(@"测试失败%@",err);
//    }];
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
