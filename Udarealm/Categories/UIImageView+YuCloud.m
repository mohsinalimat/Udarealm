//
//  UIImageView+YuCloud.m
//  YuCloud
//
//  Created by 熊国锋 on 16/3/8.
//  Copyright © 2016年 VIROYAL-ELEC. All rights reserved.
//

#import "UIImageView+YuCloud.h"

@implementation UIImageView (YuCloud)

- (void)setImage:(UIImage *)image fade:(BOOL)fade
{
    if (self.image != image) {
        [UIView transitionWithView:self duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.image = image;
                        } completion:nil];
    }
    else {
        self.image = image;
    }
}

@end
