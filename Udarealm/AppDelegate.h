//
//  AppDelegate.h
//  cards
//
//  Created by 熊国锋 on 16/5/23.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


extern NSString * NOTIFICATION_APPLICATION_BECOME_ACTIVE;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign)   CLLocationCoordinate2D  location;

+ (AppDelegate *)sharedAppDelegate;

- (NSURL *)applicationDocumentsDirectory;

@end

