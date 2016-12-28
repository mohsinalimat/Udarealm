//
//  AppDelegate.m
//  cards
//
//  Created by 熊国锋 on 16/5/23.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "AppDelegate.h"
#import "ContactParser.h"
#import "ContactDataModal.h"
#import "HomeViewController.h"
#import "SplashView.h"
#import "UdarManager.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "NSUserDefaults+YuCloud.h"

@import Firebase;

@interface AppDelegate () < SplashDelegate >

@property (nonatomic, strong)   SplashView              *splashView;
@property (nonatomic, strong)   AMapLocationManager     *locationManager;

@end

@implementation AppDelegate

+ (AppDelegate *)sharedAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Enable the XcodeColors
    setenv("XcodeColors", "YES", 0);
    
    CGRect rect = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:rect];
    
    HomeViewController *home = [[HomeViewController alloc] init];
    self.window.rootViewController = home;
    [self.window makeKeyAndVisible];
    
    [self.window addSubview:self.splashView];
    [self.splashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.window);
    }];
    
#if YUCLOUD_DEV_MODE
    // Standard lumberjack initialization
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24;         //24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
#endif //YUCLOUD_DEV_MODE
    
    // And then enable colors
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    DDLogInfo(@"\n\n\tY^o^Y %s Y^o^Y\n", __PRETTY_FUNCTION__);
    
    [Chameleon setGlobalThemeUsingPrimaryColor:FlatRed
                              withContentStyle:UIContentStyleDark];
    
    [AMapServices sharedServices].apiKey = @"5463e7bb6f16b1c16e6b4014f8d0b158";
    
    [FIRApp configure];
    
    NSLog(@"defaultRealm file: %@", [RLMRealm defaultRealm].configuration.fileURL);
    return YES;
}

- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.distanceFilter = CLLocationDistanceMax;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.allowsBackgroundLocationUpdates = NO;
    }
    
    return _locationManager;
}

- (SplashView *)splashView {
    if (!_splashView) {
        _splashView = [[SplashView alloc] init];
        _splashView.delegate = self;
    }
    
    return _splashView;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.bangwooo.cards" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSString *contact_id = url.query;
    if ([contact_id length] > 3) {
        [[UdarManager sharedClient] viewContact:contact_id];
    }
    
    return YES;
}

#pragma mark - SplashDelegate

- (void)finishSplash:(SplashView *)splash {
    if (splash == self.splashView) {
        [self.splashView removeFromSuperview];
        self.splashView = nil;
        
        [self.locationManager requestLocationWithReGeocode:NO
                                           completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
                                               self.location = location.coordinate;
                                               
                                               [NSUserDefaults saveLastLocationCoordinate:self.location];
                                           }];
    }
}

@end
