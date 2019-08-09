//
//  ALRequestMethod.m
//  IntelligentLock
//
//  Created by Orient on 2019/5/8.
//  Copyright © 2019 Orient. All rights reserved.
//

#import "ALRequestMethod.h"

@implementation ALRequestMethod

- (instancetype)init{
    self = [super init];
    if(self){
        _requestCount = 3;
        _requestType = ALPOST;
        _tryMethod = ALTryNormal;
    }
    return self;
}

- (void)setTryMethod:(ALTry)tryMethod{
    _tryMethod = tryMethod;
}
- (void)setRequestCount:(NSInteger)requestCount{
    _requestCount = requestCount;
}
- (void)setRequestType:(ALRequestType)requestType{
    _requestType = requestType;
}

@end
