//
//  ALRequestMethod.h
//  IntelligentLock
//
//  Created by Orient on 2019/5/8.
//  Copyright © 2019 Orient. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, ALTry){
    ALTryNormal = 100,
    ALTryRetry ,
};

typedef NS_ENUM(NSInteger, ALRequestType){
    ALPOST = 0,
    ALGET = 1,
    ALDELETE = 2,
    ALPUT = 3,
    ALUPLOAD = 4,
};
@interface ALRequestMethod : NSObject

@property (nonatomic, copy)NSString * url;
@property (nonatomic, strong)NSDictionary * parameter;
@property (nonatomic, assign)ALTry tryMethod;
@property (nonatomic, assign)ALRequestType requestType;
@property (nonatomic, assign)NSInteger requestCount;
@property (nonatomic, strong)NSArray * imageArray;
@property (nonatomic, copy)NSString * apiName;


@end

NS_ASSUME_NONNULL_END
