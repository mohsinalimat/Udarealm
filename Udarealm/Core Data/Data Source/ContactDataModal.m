//
//  ContactDataModal.m
//  Doubi
//
//  Created by 熊国锋 on 16/4/27.
//  Copyright © 2016年 Nanjing Viroyal. All rights reserved.
//

#import "ContactDataModal.h"
#import "AppDelegate.h"
#import "NSUserDefaults+Udar.h"
#import "ContactParser.h"


@interface FetchData : NSObject

@property (atomic, assign)      NSInteger       count;
@property (nonatomic, copy)     NSArray         *fetchedObjects;

@end

@implementation FetchData

- (void)dealloc {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

@end

#pragma mark - ContactDataModal

@interface ContactDataModal ()

@property (atomic, assign)      BOOL                    busy;

@end

@implementation ContactDataModal

+ (ContactDataModal *)sharedClient
{
    static ContactDataModal *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ContactDataModal alloc] init];
    });
    
    return _sharedClient;
}

- (NSOperationQueue *)operationQueue {
    static NSOperationQueue *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NSOperationQueue alloc] init];
        _sharedClient.name = @"ContactDataModal Queue";
        _sharedClient.maxConcurrentOperationCount = 1;
    });
    
    return _sharedClient;
}

- (void)initContacts {
    if (self.busy || [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] != CNAuthorizationStatusAuthorized) {
        return;
    }
    
    NSDate *lastInit = [NSUserDefaults lastInitDate];
    if (lastInit && -[lastInit timeIntervalSinceNow] < 30 * 1) {
        return;
    }
    
    self.busy = YES;
    WEAK(self, wself);
    [self addObject:initContactData block:^(BOOL success, NSDictionary * _Nullable info) {
        wself.busy = NO;
        [NSUserDefaults saveLastInitDate:[NSDate date]];
    }];
    
    [[ContactParser sharedClient] performSelector:@selector(startParse)
                                       withObject:nil
                                       afterDelay:3];
}

- (UIImage *)imageWithKey:(NSString *)key {
    AvatarImage *info = [AvatarImage objectForPrimaryKey:key];
    if (info) {
        return [UIImage imageWithData:info.imageData];
    }
    
    return nil;
}

- (void)receiveMemoryWarning {
    [super receiveMemoryWarning];
}

@end
