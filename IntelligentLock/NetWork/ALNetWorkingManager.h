//
//  ALNetWorkingManager.h
//  IntelligentLock
//
//  Created by Orient on 2019/5/8.
//  Copyright © 2019 Orient. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALRequestMethod.h"
#import <AFNetworking/AFNetworking.h>
NS_ASSUME_NONNULL_BEGIN


typedef BOOL (^ALSuccessBlock)(id _Nullable responseObject);
typedef BOOL (^ALFailureBlock)(NSError *error);

@interface ALNetWorkingManager : NSObject

+ (ALNetWorkingManager *)shareManager;


@property (nonatomic, strong,readonly) AFHTTPSessionManager * requestManager;



- (void)dataWithRequest:(ALRequestMethod *)requestMethod success:(ALSuccessBlock)success failure:(ALFailureBlock)failure;


- (void)dataFromApi:(NSString *)apiName
         parameters:(ALRequestMethod *)parameters
            success:(BOOL (^)(id result))success
            failure:(BOOL (^)(NSError *err))failure;
@end

NS_ASSUME_NONNULL_END
