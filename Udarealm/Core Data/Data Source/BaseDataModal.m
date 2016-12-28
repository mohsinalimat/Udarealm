//
//  BaseDataModal.m
//  YuCloud
//
//  Created by 熊国锋 on 16/3/24.
//  Copyright © 2016年 VIROYAL-ELEC. All rights reserved.
//

#import "BaseDataModal.h"
#import "AppDelegate.h"



@interface BaseDataModal ()

@property (nonatomic, strong)   NSMutableDictionary             *operations;


@end

@implementation BaseDataModal

- (ObjectProcessor *)newProcessor {
    ObjectProcessor *processor = [[ObjectProcessor alloc] init];
    
    processor.delegate = self;
    
    return processor;
}

- (NSMutableDictionary *)operations {
    if (_operations == nil) {
        _operations = [NSMutableDictionary dictionaryWithCapacity:20];
    }
    
    return _operations;
}

- (NSOperation *)addOperation:(ObjectProcessor *)operation wait:(BOOL)wait finishBlock:(CommonBlock)block {
    [self.operationQueue addOperations:@[operation] waitUntilFinished:wait];
    
    if (block) {
        [self.operations setObject:block forKey:operation.identifier];
    }
    
    return operation;
}

- (void)processDidFinished:(ObjectProcessor *)processor {
    if ([NSThread isMainThread]) {
        CommonBlock block = [self.operations objectForKey:processor.identifier];
        if (block) {
            block(YES, nil);
        }
        [self.operations removeObjectForKey:processor.identifier];
    }
    else {
        [self performSelectorOnMainThread:@selector(processDidFinished:)
                               withObject:processor
                            waitUntilDone:NO];
    }
}

- (NSOperation *)addObject:(id)data {
    return [self addObject:data block:nil];
}

- (NSOperation *)addObject:(id)data block:(CommonBlock)block {
    ObjectProcessor *process = [self newProcessor];
    [process.insertDataInfo addObject:data];
    process.queuePriority = NSOperationQueuePriorityVeryLow;
    
    return [self addOperation:process wait:NO finishBlock:block];
}

- (void)editObject:(id)data {
    ObjectProcessor *process = [self newProcessor];
    [process.editDataInfo addObject:data];
    
    [self addOperation:process wait:NO finishBlock:nil];
}

- (void)clearData:(id)data {
    ObjectProcessor *process = [self newProcessor];
    [process.clearDataInfo addObject:data];
    
    [self addOperation:process wait:NO finishBlock:nil];
}

- (void)clearUnread:(id)data {
    ObjectProcessor *process = [self newProcessor];
    [process.clearUnreadInfo addObject:data];
    
    [self addOperation:process wait:NO finishBlock:nil];
}

#pragma mark - ObjectProcessDelegate


- (void)receiveMemoryWarning {
}

@end
