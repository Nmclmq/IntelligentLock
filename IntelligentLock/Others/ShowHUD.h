//
//  ShowHUD.h
//  IntelligentLock
//
//  Created by Orient on 2019/4/28.
//  Copyright © 2019 Orient. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
NS_ASSUME_NONNULL_BEGIN

@interface ShowHUD : NSObject


+(void)showError:(NSString *)error;
+(void)showMessage:(NSString *)message;
+(void)showSuccess:(NSString *)success;
+(void)showLoading;
+(void)showLoadingWithMessage:(NSString *)message;
+(void)hideHUD;

+(void)showWaiting;
+(void)showSaving;
@end

NS_ASSUME_NONNULL_END
