//
//  ContactParser.m
//  cards
//
//  Created by 熊国锋 on 16/5/23.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "ContactParser.h"
#import "PhoneRegionParseInterface.h"
#import "ContactDataModal.h"
#import "AppDelegate.h"
#import "ParseInfo.h"


#pragma mark - ParseData

@interface ParseData ()

@end

@implementation ParseData

- (instancetype)initWithInfo:(ParseInfo *)info {
    if (self = [super init]) {
        self.province   = info.province;
        self.city       = info.city;
        self.cityCode   = info.cityCode;
        self.mobileCode = info.mobileCode;
        self.opName     = info.opName;
        self.zipCode    = info.zipCode;
    }
    
    return self;
}

@end

#pragma mark - ContactParser

@interface ContactParser () < BaseDataModalDelegate >

@property (nonatomic, strong)   RLMNotificationToken    *token;

@end

@implementation ContactParser

+ (instancetype)sharedClient {
    static ContactParser *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ContactParser alloc] init];
    });
    
    return _sharedClient;
}

- (instancetype)init {
    if (self = [super init]) {
        [self copyParsedb];
    }
    
    return self;
}

- (NSOperationQueue *)operationQueue {
    static NSOperationQueue *_sharedQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedQueue = [[NSOperationQueue alloc] init];
        _sharedQueue.name = @"ContactParser queue";
        _sharedQueue.maxConcurrentOperationCount = 1;
    });
    
    return _sharedQueue;
}

- (void)startParse {
    [self.token stop];
    self.token = [[ContactInfo objectsWhere:@"refCount == 1 && state == 0"] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if ([change.insertions count] || [change.modifications count]) {
            [self parsePatch];
        }
    }];
    
    [self parsePatch];
}

- (void)parsePatch {
    if (self.busy) {
        [self performSelector:@selector(parsePatch)
                   withObject:nil
                   afterDelay:1];
    }
    
    RLMResults *results = [ContactInfo objectsWhere:@"refCount == 1 && state == 0"];
    if ([results count] == 0) {
        return;
    }
    
    WEAK(self, wself);
    wself.busy = YES;
    [self addObject:parseContactData
              block:^(BOOL success, NSDictionary * _Nullable info) {
                  wself.busy = NO;
              }];
}

- (void)copyParsedb {
    BOOL import = YES;
    if (import) {
        if ([[ParseInfo allObjects] count] > 0) {
            return;
        }
        
        NSURL *dbURL = [[NSBundle mainBundle] URLForResource:@"parse" withExtension:@"plist"];
        NSArray *source = [NSArray arrayWithContentsOfURL:dbURL];
        
        [[RLMRealm defaultRealm] beginWriteTransaction];
        for (NSDictionary *item in source) {
            NSString *mobileCode = item[@"mobileCode"];
            ParseInfo *info = [[ParseInfo alloc] initWithMobileCode:mobileCode];
            [[RLMRealm defaultRealm] addObject:info];
            
            info.province   = item[@"province"];
            info.city       = item[@"city"];
            info.cityCode   = item[@"cityCode"];
            info.zipCode    = item[@"zipCode"];
            info.opName     = item[@"operator"];
        }
        
        [[RLMRealm defaultRealm] commitWriteTransaction];
    }
    else {
        NSURL *dbURL = [[[AppDelegate sharedAppDelegate] applicationDocumentsDirectory] URLByAppendingPathComponent:@"parse.plist"];
        RLMResults *results = [ParseInfo allObjects];
        NSMutableArray *dest = [NSMutableArray arrayWithCapacity:5000];
        for (ParseInfo *item in results) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
            
            [dic setValue:item.province forKey:@"province"];
            [dic setValue:item.city forKey:@"city"];
            [dic setValue:item.cityCode forKey:@"cityCode"];
            [dic setValue:item.mobileCode forKey:@"mobileCode"];
            [dic setValue:item.zipCode forKey:@"zipCode"];
            [dic setValue:item.opName forKey:@"operator"];
            
            [dest addObject:dic];
        }
        
        [dest writeToURL:dbURL atomically:YES];
    }
}

@end
