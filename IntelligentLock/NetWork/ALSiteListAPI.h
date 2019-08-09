//
//  ALSiteListAPI.h
//  IntelligentLock
//
//  Created by Orient on 2019/5/13.
//  Copyright © 2019 Orient. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SiteModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALSiteListAPI : NSObject

+(void)getDisCountsWithStartIndex:(NSInteger )page
                         success:(BOOL (^)(id data))success
                          failure:(BOOL (^)(NSError *err))failure;
@end

NS_ASSUME_NONNULL_END
