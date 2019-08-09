//
//  ALSiteListAPI.m
//  IntelligentLock
//
//  Created by Orient on 2019/5/13.
//  Copyright © 2019 Orient. All rights reserved.
//

#import "ALSiteListAPI.h"

@implementation ALSiteListAPI

+(void)getDisCountsWithStartIndex:(NSInteger )page
                          success:(BOOL (^)(id data))success
                          failure:(BOOL (^)(NSError *err))failur{
        ALRequestMethod * method = [[ALRequestMethod alloc]init];
        method.requestType = ALGET;
        method.tryMethod = ALTryRetry;
        method.apiName = @"Site Data";
        method.url = @"http://t.weather.sojson.com/api/weather/city/101030100";

    [[ALNetWorkingManager shareManager] dataFromApi:@"Site Data" parameters:method success:^BOOL(id  _Nonnull result) {
        return success(result);
    } failure:^BOOL(NSError * _Nonnull err) {
        return failur(err);
        
    }];
}

@end


