//
//  ShowHUD.m
//  IntelligentLock
//
//  Created by Orient on 2019/4/28.
//  Copyright © 2019 Orient. All rights reserved.

#import "ShowHUD.h"
@implementation ShowHUD

+(void)showError:(NSString *)error{
    
    AL_Dispatch_Async_Main(^{
        [self hideHUD];
        MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:[self getView]];
        HUD.contentColor=[UIColor whiteColor];
        HUD.bezelView.color=[UIColor blackColor];
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconHUDWarning"]];
        HUD.mode=MBProgressHUDModeCustomView;
        HUD.label.text=error;
        HUD.label.numberOfLines = 0;
        HUD.removeFromSuperViewOnHide=YES;
        [[self getView] addSubview:HUD];
        [HUD showAnimated:YES];
        [HUD hideAnimated:YES afterDelay:1];
        
    });
    
    if([NSThread isMainThread]){
        
    }else{
        
    }
}
+(void)showMessage:(NSString *)message{
    AL_Dispatch_Async_Main(^{
        [self hideHUD];
        MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:[self getView]];
        HUD.contentColor=[UIColor whiteColor];
        HUD.bezelView.color=[UIColor blackColor];
        HUD.mode=MBProgressHUDModeText;
        HUD.label.text=message;
        HUD.label.numberOfLines = 0;
        HUD.removeFromSuperViewOnHide=YES;
        [[self getView] addSubview:HUD];
        [HUD showAnimated:YES];
        [HUD hideAnimated:YES afterDelay:1];
    });
}
+(void)showSuccess:(NSString *)success{
    AL_Dispatch_Async_Main(^{
        [self hideHUD];
        MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:[self getView]];
        HUD.contentColor=[UIColor whiteColor];
        HUD.bezelView.color=[UIColor blackColor];
        HUD.mode=MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconHUDYes"]];
        HUD.label.text=success;
        HUD.label.numberOfLines = 0;
        HUD.removeFromSuperViewOnHide=YES;
        [[self getView] addSubview:HUD];
        [HUD showAnimated:YES];
        [HUD hideAnimated:YES afterDelay:1];
        
    });
}
+(void)showLoading{
    AL_Dispatch_Async_Main(^{
        MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:[self getView]];
        HUD.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
        HUD.bezelView.color = [UIColor blackColor];
        HUD.contentColor=[UIColor whiteColor];
        HUD.label.text=@"正在加载";
        HUD.removeFromSuperViewOnHide=YES;
        [[self getView] addSubview:HUD];
        [HUD showAnimated:YES];
    });
}
+(void)showLoadingWithMessage:(NSString *)message{
    AL_Dispatch_Async_Main(^{
        MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:[self getView]];
        HUD.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
        HUD.bezelView.color = [UIColor blackColor];
        HUD.contentColor=[UIColor whiteColor];
        HUD.label.text=message;
        HUD.label.numberOfLines = 0;
        HUD.removeFromSuperViewOnHide=YES;
        [[self getView] addSubview:HUD];
        [HUD showAnimated:YES];
        
    });
}
+(void)hideHUD{
    AL_Dispatch_Async_Main(^{
        [MBProgressHUD hideHUDForView:[self getView] animated:YES];
    });
}
+(void)showWaiting{
    AL_Dispatch_Async_Main(^{
        MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:[self getView]];
        HUD.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
        HUD.bezelView.color = [UIColor blackColor];
        HUD.contentColor=[UIColor whiteColor];
        HUD.removeFromSuperViewOnHide=YES;
        [[self getView] addSubview:HUD];
        [HUD showAnimated:YES];
    });
}
+(void)showSaving{
    AL_Dispatch_Async_Main(^{
        MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:[self getView]];
        HUD.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
        HUD.bezelView.color = [UIColor blackColor];
        HUD.contentColor=[UIColor whiteColor];
        HUD.label.text=@"正在保存";
        HUD.removeFromSuperViewOnHide=YES;
        [[self getView] addSubview:HUD];
        [HUD showAnimated:YES];
    });
}

+(UIWindow *)getView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    return window;
}
@end
