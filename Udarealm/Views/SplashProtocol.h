//
//  SplashProtocol.h
//  Udar
//
//  Created by 熊国锋 on 2016/8/22.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

@protocol SplashPageProtocol <NSObject>

- (void)showNextPageOf:(UIViewController *)viewController;
- (void)finishPageOf:(UIViewController *)viewController;

@end
