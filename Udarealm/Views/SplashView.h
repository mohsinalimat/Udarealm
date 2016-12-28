//
//  SplashView.h
//  Udar
//
//  Created by 熊国锋 on 2016/8/21.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashProtocol.h"

@class SplashView;

@protocol SplashDelegate <NSObject>

- (void)finishSplash:(SplashView *)splash;

@end


@interface SplashView : UIView

@property (nonatomic, weak) id <SplashDelegate>     delegate;

@end
