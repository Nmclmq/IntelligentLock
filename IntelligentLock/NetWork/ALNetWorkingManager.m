//
//  ALNetWorkingManager.m
//  IntelligentLock
//
//  Created by Orient on 2019/5/8.
//  Copyright © 2019 Orient. All rights reserved.
//

#import "ALNetWorkingManager.h"


static const int _maxCurrentNumber = 3;

@interface ALNetWorkingManager()
/**
 请求request数据
 */
@property (nonatomic, strong) NSMutableArray *requestQueue;

/**
 成功回调的request数据
 */
@property (nonatomic, strong) NSMutableArray *successQueue;

/**
 存放request的失败回调
 */
@property (nonatomic, strong) NSMutableArray *failureQueue;

@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)dispatch_semaphore_t semaphore;
@property (nonatomic, strong)dispatch_queue_t addDelQueue;
@end

@implementation ALNetWorkingManager
- (NSMutableArray *)requestQueue{
    if (!_requestQueue) {
        _requestQueue=[[NSMutableArray alloc] init];
    }return _requestQueue;
}
- (NSMutableArray *)successQueue{
    if (!_successQueue) {
        _successQueue=[[NSMutableArray alloc] init];
    }return _successQueue;
}

- (NSMutableArray *)failureQueue{
    if (!_failureQueue) {
        _failureQueue=[[NSMutableArray alloc] init];
    }return _failureQueue;
}
- (dispatch_queue_t)addDelQueue
{
    if (!_addDelQueue)
    {
        _addDelQueue = dispatch_queue_create("com.addDel.www", DISPATCH_QUEUE_SERIAL);
    }
    return _addDelQueue;
}
+ (ALNetWorkingManager *)shareManager{
    static ALNetWorkingManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc]init];
    });
    return manager;
}

- (id)init{
    if(self = [super init]){
         [self startTimer];
        self.semaphore = dispatch_semaphore_create(_maxCurrentNumber);
        _requestManager = [AFHTTPSessionManager manager];
        [_requestManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        [_requestManager.requestSerializer setTimeoutInterval:0.0f];
        [_requestManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        NSMutableSet * set = [NSMutableSet setWithSet:_requestManager.responseSerializer.acceptableContentTypes];
        [set addObject:@"text/html"];
        [set addObject:@"multipart/form-data"];
        [set addObject:@"Accept"];
        [set addObject:@"text/plain"];
        [set addObject:@"text/json"];
        [set addObject:@"application/json"];
        
        _requestManager.responseSerializer.acceptableContentTypes = set;
        
        _requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}
-(void)dataWithRequest:(ALRequestMethod *)requestMethod success:(ALSuccessBlock)success failure:(ALFailureBlock)failure{
    if(!requestMethod.url){
        [ShowHUD showError:@"请求地址为空"];
        return;
    }
    if(!requestMethod){
        [ShowHUD showError:@"请求出错"];
        return;
    }
    if(requestMethod.requestCount > 0){
        [self request:requestMethod sucees:success failure:failure]; 
    }
    NSLog(@"=======>%ld",requestMethod.requestCount);
}

#pragma mark Timer
- (void)startTimer{
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateTimer) userInfo:nil repeats:true];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}
- (void)updateTimer{
//    NSLog(@"123");
//    while(self.requestQueue.count>0) {
//        ALRequestMethod *request;
//        ALSuccessBlock success;
//        ALFailureBlock failure;
//        if (self.requestQueue.count >= 1)
//        {
//            [self.requestQueue removeObjectAtIndex:0];
//            [self.successQueue removeObjectAtIndex:0];
//            [self.failureQueue removeObjectAtIndex:0];
//        }
//        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        //发送请求
//        [self request:request sucees:success failure:failure];
//    }
      [self dealRequest];
}

- (void)request:(ALRequestMethod *)request sucees:(ALSuccessBlock)success failure:(ALFailureBlock)failure{
    if (request==nil) {
        return;
    }
    // 将请求保存起来
    dispatch_async(self.addDelQueue, ^{
        if ([self.requestQueue containsObject:request]) return;
        if (request.requestCount>0) {
            NSLog(@"处理的第 %ld 次请求",request.requestCount);
            [self.requestQueue addObject:request];
            //做容错处理，如果block为空，设置默认block
            id tmpBlock = [success copy];
            if (success == nil)
            {
                tmpBlock = [^(id obj){} copy];
            }
            [self.successQueue addObject:tmpBlock];
            tmpBlock = [failure copy];
            if (failure == nil)
            {
                tmpBlock = [^(id obj){} copy];
            }
            [self.failureQueue addObject:tmpBlock];
            [self dealRequest];
        }
    });
}
/**
 处理请求
 */
- (void)dealRequest{
    while (self.requestQueue.count > 0) {
        ALRequestMethod * request = self.requestQueue.firstObject;
        ALSuccessBlock success = self.successQueue.firstObject;
        ALFailureBlock failure = self.failureQueue.firstObject;
        if(self.requestQueue.count >=1){
            [self.requestQueue removeObjectAtIndex:0];
            [self.successQueue removeObjectAtIndex:0];
            [self.failureQueue removeObjectAtIndex:0];
        }
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        //发送请求
        switch (request.requestType) {
            case 0:{
                [self.requestManager POST:request.url parameters:request.parameter progress:^(NSProgress * _Nonnull uploadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self requestDataComplete:success data:responseObject];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self requestDataFail:failure request:request success:success error:error];
                }];
            }
                break;
            case 1:{
                [self.requestManager GET:request.url parameters:request.parameter progress:^(NSProgress * _Nonnull downloadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self requestDataComplete:success data:responseObject];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self requestDataFail:failure request:request success:success error:error];
                }];
            }
                break;
            case 2:{
                [self.requestManager DELETE:request.url parameters:request.parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self requestDataComplete:success data:responseObject];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self requestDataFail:failure request:request success:success error:error];
                }];
            }
                break;
            case 3:{
                [self.requestManager PUT:request.url parameters:request.parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self requestDataComplete:success data:responseObject];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self requestDataFail:failure request:request success:success error:error];
                }];
            }
                break;
            case 4:{
                
            }
                break;
            default:
                NSLog(@"错误");
                break;
        }
    }
}

#pragma make private class  request data use
- (void)requestDataComplete:(ALSuccessBlock)success data:(id _Nullable )responseObject{
//  dispatch_semaphore_signal(self.semaphore);
    if(success){
        success(responseObject);
    }
}

- (void)requestDataFail:(ALFailureBlock)failure request:(ALRequestMethod *)request success:(ALSuccessBlock)success error:(NSError * _Nonnull)error{
    dispatch_semaphore_signal(self.semaphore);
    if (failure) {
        failure(error);
    }
    if (request.tryMethod==ALTryRetry) {
        request.requestCount--;
    }else if (request.tryMethod==ALTryNormal){
        request.requestCount=0;
    }
    //添加次数请求数据
    [self dataWithRequest:request success:success failure:failure];
}
//- (void)dataFromApi:(NSString *)apiName
//         parameters:(ALRequestMethod *)parameters
//            success:(ALSuccessBlock)success failure:(ALFailureBlock)failure{
//    if(!parameters.url){
//        [ShowHUD showError:@"请求地址为空"];
//        return;
//    }
//    if(!parameters){
//        [ShowHUD showError:@"请求出错"];

//        return;
//    }
//    if(parameters.requestCount > 0){
//        [self request:parameters sucees:success failure:failure];
//    }
//}
- (void)dataFromApi:(NSString *)apiName
         parameters:(ALRequestMethod *)parameters
            success:(BOOL (^)(id result))success
            failure:(BOOL (^)(NSError *err))failure{
    switch (parameters.requestType) {
        case 0:{
            [self.requestManager POST:parameters.url parameters:parameters.parameter progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                [self requestDataComplete:success data:responseObject];
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self requestDataFail:failure request:parameters success:success error:error];
            }];
        }
            break;
        case 1:{
            [self.requestManager GET:parameters.url parameters:parameters.parameter progress:^(NSProgress * _Nonnull downloadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                [self requestDataComplete:success data:responseObject];
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self requestDataFail:failure request:parameters success:success error:error];
            }];
        }
            break;
        case 2:{
            [self.requestManager DELETE:parameters.url parameters:parameters.parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                [self requestDataComplete:success data:responseObject];
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self requestDataFail:failure request:parameters success:success error:error];
            }];
        }
            break;
        case 3:{
            [self.requestManager PUT:parameters.url parameters:parameters.parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                [self requestDataComplete:success data:responseObject];
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self requestDataFail:failure request:parameters success:success error:error];
            }];
        }
            break;
        case 4:{
            
        }
            break;
            
        default:
            NSLog(@"错误");
            break;
    }
}
@end
