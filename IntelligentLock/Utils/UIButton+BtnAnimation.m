//
//  UIButton+BtnAnimation.m
//  IntelligentLock
//
//  Created by Orient on 2019/5/8.
//  Copyright © 2019 Orient. All rights reserved.
//

#import "UIButton+BtnAnimation.h"

@implementation UIButton (BtnAnimation)
-(void)customButtonAnimation{
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
            
            self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
            
            self.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
            
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}
@end
